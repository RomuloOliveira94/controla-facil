class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.column :cat_sub, "ENUM('expenses', 'incomes')" # 0 for expenses, 1 for incomes
      t.timestamps
    end
  end
end
