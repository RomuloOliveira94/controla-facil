class ChangeCategoriesCatSubToString < ActiveRecord::Migration[7.1]
  def up
    execute "UPDATE categories SET cat_sub = 'expenses' WHERE cat_sub NOT IN ('expenses','incomes') OR cat_sub IS NULL"
    change_column :categories, :cat_sub, :string, limit: 10, null: false
  end

  def down
    change_column :categories, :cat_sub, "ENUM('expenses','incomes')"
  end
end
