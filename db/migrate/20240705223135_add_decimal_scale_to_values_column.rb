class AddDecimalScaleToValuesColumn < ActiveRecord::Migration[7.1]
  def change
    change_column :expenses, :value, :decimal, precision: 10, scale: 2
    change_column :incomes, :value, :decimal, precision: 10, scale: 2
    change_column :balances, :balance, :decimal, precision: 10, scale: 2
  end
end
