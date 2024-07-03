class AddIncomeAndExpenseToBalance < ActiveRecord::Migration[7.1]
  def change
    add_reference :incomes, :balance, null: false, foreign_key: true
    add_reference :expenses, :balance, null: false, foreign_key: true
  end
end
