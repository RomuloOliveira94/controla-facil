class AddCategoryIdToIncomesAndExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :incomes, :category, null: false, foreign_key: true
    add_reference :expenses, :category, null: false, foreign_key: true
  end
end
