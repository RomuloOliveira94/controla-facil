class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      # Historicamente esta coluna era um ENUM nativo do MySQL. A migration
      # 20260803141200 já a converte para string, mas esta definição precisa
      # continuar executável em bancos que não entendem ENUM (SQLite), senão
      # `db:migrate` do zero quebra. No MySQL mantemos o tipo original para
      # preservar a fidelidade histórica da cadeia de migrations.
      if mysql?
        t.column :cat_sub, "ENUM('expenses', 'incomes')"
      else
        t.string :cat_sub, limit: 10
      end
      t.timestamps
    end
  end

  private

  def mysql?
    adapter_name = connection.adapter_name.downcase
    adapter_name.include?('mysql') || adapter_name.include?('trilogy')
  end
end
