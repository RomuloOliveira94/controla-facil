require 'test_helper'

# db/seeds.rb usa find_or_create_by! com cat_sub. Enquanto a coluna era ENUM o
# MySQL convertia os inteiros 1/2 em 'expenses'/'incomes' na escrita, mas o
# find_or_create_by! comparava contra os inteiros, então rodar os seeds duas vezes
# duplicava todas as categorias fixas. Este teste trava a idempotência.
class SeedsTest < ActiveSupport::TestCase
  test 'rodar os seeds duas vezes mantém as categorias fixas estáveis' do
    Rails.application.load_seed
    first_run = Category.where(fixed: true).count

    assert_operator first_run, :>, 0

    Rails.application.load_seed

    assert_equal first_run, Category.where(fixed: true).count
  end

  test 'seeds gravam cat_sub como string' do
    Rails.application.load_seed

    assert_equal %w[expenses incomes], Category.where(fixed: true).distinct.pluck(:cat_sub).sort
  end

  test 'seeds criam categorias fixas válidas' do
    Rails.application.load_seed

    Category.where(fixed: true).find_each do |category|
      assert_predicate category, :valid?
    end
  end

  # No primeiro boot após a migração para SQLite, a criação do banco da fila faz
  # o db:prepare rodar os seeds com o banco primário já populado pela cópia do
  # MySQL. Se o matcher levasse description ou icon em conta, qualquer diferença
  # nesses textos criaria uma segunda categoria fixa com o mesmo nome.
  test 'seeds não duplicam categoria existente com description e icon diferentes' do
    # parte de um estado conhecido: o banco de teste pode ter sobras de outros usos
    Category.where(name: 'Alimentação', cat_sub: 'expenses').delete_all
    existente = Category.create!(
      name: 'Alimentação',
      cat_sub: 'expenses',
      description: 'TEXTO DIVERGENTE',
      icon: 'fas fa-outro-icone',
      fixed: true
    )

    assert_no_difference -> { Category.where(name: 'Alimentação', cat_sub: 'expenses').count } do
      Rails.application.load_seed
    end

    assert_equal 1, Category.where(name: 'Alimentação', cat_sub: 'expenses').count
    # a linha existente é preservada como está: o bloco só roda na criação
    assert_equal 'TEXTO DIVERGENTE', existente.reload.description
    assert_equal 'fas fa-outro-icone', existente.icon
  end

  test 'seeds distinguem Outras de despesa e Outras de receita' do
    Rails.application.load_seed

    outras = Category.where(name: 'Outras', fixed: true)

    assert_equal 2, outras.count
    assert_equal %w[expenses incomes], outras.pluck(:cat_sub).sort
  end

  test 'o par name e cat_sub identifica unicamente cada categoria fixa' do
    Category.delete_all
    Rails.application.load_seed

    pares = Category.where(fixed: true).pluck(:name, :cat_sub)

    assert_equal pares.size, pares.uniq.size
  end
end
