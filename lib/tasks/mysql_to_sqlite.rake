# Pipeline de cópia de dados MySQL -> SQLite.
#
# `db:copy_from_mysql` lê do banco apontado por SOURCE_DATABASE_URL (MySQL) e
# grava na conexão corrente da aplicação (SQLite). `db:verify_copy` compara os
# dois lados e aborta em qualquer divergência.
#
# A cópia é feita com SQL cru (select_all + INSERT em lote). Nenhum modelo do
# Active Record é carregado de propósito: o concern UpdateBalanceValue tem
# callbacks after_save/after_destroy que recalculariam balances.balance durante
# a cópia e corromperiam os valores vindos do MySQL.
#
# ---------------------------------------------------------------------------
# COMO RODAR
# ---------------------------------------------------------------------------
# A gem mysql2 está no grupo opcional `data_migration` do Gemfile e não compila
# em máquinas sem os headers do cliente MySQL (libmysqlclient/libmariadb-dev).
# Por isso o pipeline roda dentro de um container, que tem os headers e opta
# pelo grupo explicitamente.
#
#   # 1) container com Ruby + headers do MySQL, com o repo montado
#   docker run -d --name cf-copy --network host \
#     -v "$PWD":/app -w /app ruby:3.3.0-slim sleep infinity
#
#   docker exec cf-copy bash -lc '
#     apt-get update -qq &&
#     apt-get install -y -qq --no-install-recommends \
#       default-libmysqlclient-dev build-essential git libvips pkg-config'
#
#   # 2) opta pelo grupo data_migration (instala o mysql2)
#   docker exec cf-copy bash -lc '
#     cd /app && bundle config set --local with data_migration && bundle install'
#
#   # 3) prepara o SQLite de destino e copia
#   docker exec \
#     -e DATABASE_URL='sqlite3:storage/production.sqlite3' \
#     -e SOURCE_DATABASE_URL='mysql2://root:SENHA@127.0.0.1:3306/controla_facil_production' \
#     cf-copy bash -lc 'cd /app && bin/rails db:schema:load db:copy_from_mysql db:verify_copy'
#
#   # 4) compacta e checa o arquivo final
#   sqlite3 storage/production.sqlite3 \
#     'PRAGMA wal_checkpoint(TRUNCATE); VACUUM; PRAGMA integrity_check;'
#
#   # 5) limpeza
#   docker rm -f cf-copy
#
# Notas operacionais verificadas no ensaio:
#
# * A imagem oficial `ruby` define BUNDLE_APP_CONFIG=/usr/local/bundle, então
#   `bundle config set --local` grava dentro do container e NÃO cria .bundle/
#   no repo montado. O Gemfile.lock também não é alterado. Nada a limpar no
#   host (de qualquer forma /.bundle já está no .gitignore e no .dockerignore).
#
# * O container roda como root, então o arquivo .sqlite3 gerado fica com dono
#   root no host. Rode `chown` antes de mexer nele fora do container:
#     docker exec cf-copy chown -R "$(id -u):$(id -g)" /app/storage
#
# * `db:schema:load` grava ar_internal_metadata.environment com o RAILS_ENV da
#   execução. Se a cópia rodar fora de produção, corrija antes do cutover:
#     sqlite3 storage/production.sqlite3 \
#       "UPDATE ar_internal_metadata SET value='production' WHERE key='environment';"
#
# * NÃO rode `db:migrate` apontando para o MySQL com o repositório montado: o
#   dump automático reescreve db/schema.rb no formato do MySQL (com
#   charset/collation e FKs bigint) e desfaz o schema nativo do SQLite. Os
#   passos acima usam só `db:schema:load`, que não faz dump. Se precisar
#   migrar a origem, confira `git status db/schema.rb` depois.
#
# * Qualquer `db:migrate` avulso contra o MySQL dentro do container também
#   precisa das variáveis do R2, mesmo que com valores fictícios:
#     -e R2_BUCKET=x -e R2_ENDPOINT=https://x \
#     -e R2_ACCESS_KEY_ID=x -e R2_SECRET_ACCESS_KEY=x
#   Sem elas o boot carrega os modelos, o `has_one_attached :avatar` do User
#   tenta resolver o service do Active Storage e a falha aparece como
#   `ArgumentError: missing required option :name`, que não sugere em nada a
#   causa real. A sequência de 3 comandos documentada acima NÃO precisa dessas
#   variáveis, porque só usa SQL cru e não instancia os modelos.
#
# * Na checagem "users com e-mail não normalizado", um FAIL no formato
#   `origem=0 destino=N` NÃO indica defeito na cópia. A comparação `email <>
#   LOWER(email)` roda com a collation case-insensitive do MySQL, que considera
#   'Foo@BAR.com' igual a 'foo@bar.com' e devolve 0; no SQLite a comparação é
#   binária e os mesmos registros aparecem. Ou seja, a origem tem e-mails
#   legados fora do padrão que o MySQL escondia. Corrija na origem (a migration
#   20260803141300 faz exatamente isso) e refaça a cópia.
namespace :db do
  # Ordem de dependência de FK: pais antes dos filhos.
  COPY_TABLES = %w[
    users
    categories
    balances
    expenses
    incomes
    push_subscriptions
    active_storage_blobs
    active_storage_attachments
    active_storage_variant_records
  ].freeze

  INSERT_BATCH_SIZE = 200

  class MysqlSource < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    self.abstract_class = true
  end

  desc 'Copia os dados do MySQL (SOURCE_DATABASE_URL) para a conexão corrente (SQLite)'
  task copy_from_mysql: :environment do
    MysqlSource.establish_connection(ENV.fetch('SOURCE_DATABASE_URL'))

    source = MysqlSource.connection
    target = ActiveRecord::Base.connection

    puts "origem : #{source.adapter_name} / #{source.current_database}"
    puts "destino: #{target.adapter_name} / #{target.pool.db_config.database}"
    puts

    target.disable_referential_integrity do
      COPY_TABLES.each do |table|
        unless source.table_exists?(table)
          puts format('%-32s IGNORADA (não existe na origem)', table)
          next
        end

        target.execute("DELETE FROM #{target.quote_table_name(table)}")

        rows = source.select_all("SELECT * FROM #{source.quote_table_name(table)}").to_a
        if rows.empty?
          puts format('%-32s 0 linhas', table)
          next
        end

        columns = rows.first.keys
        quoted_table = target.quote_table_name(table)
        quoted_columns = columns.map { |c| target.quote_column_name(c) }.join(', ')

        rows.each_slice(INSERT_BATCH_SIZE) do |batch|
          values = batch.map do |row|
            "(#{columns.map { |c| target.quote(row[c]) }.join(', ')})"
          end.join(', ')

          target.execute("INSERT INTO #{quoted_table} (#{quoted_columns}) VALUES #{values}")
        end

        puts format('%-32s %d linhas', table, rows.size)
      end
    end

    puts
    puts 'cópia concluída.'
  end

  desc 'Compara origem (SOURCE_DATABASE_URL) e destino após a cópia'
  task verify_copy: :environment do
    MysqlSource.establish_connection(ENV.fetch('SOURCE_DATABASE_URL'))

    source = MysqlSource.connection
    target = ActiveRecord::Base.connection
    failures = []

    check = lambda do |label, sql|
      expected = source.select_value(sql).to_s
      actual = target.select_value(sql).to_s
      ok = expected == actual
      failures << label unless ok
      puts format('%-4s %-46s origem=%-16s destino=%s', ok ? 'OK' : 'FAIL', label, expected, actual)
    end

    COPY_TABLES.each do |table|
      next unless source.table_exists?(table)

      check.call("COUNT(*) #{table}", "SELECT COUNT(*) FROM #{table}")
    end

    check.call('SUM(value) expenses', 'SELECT ROUND(COALESCE(SUM(value), 0), 2) FROM expenses')
    check.call('SUM(value) incomes', 'SELECT ROUND(COALESCE(SUM(value), 0), 2) FROM incomes')
    check.call('SUM(balance) balances', 'SELECT ROUND(COALESCE(SUM(balance), 0), 2) FROM balances')
    check.call('users com e-mail não normalizado', 'SELECT COUNT(*) FROM users WHERE email <> LOWER(email)')

    puts
    abort("verificação FALHOU em: #{failures.join(', ')}") if failures.any?

    puts 'verificação OK: origem e destino conferem.'
  end
end
