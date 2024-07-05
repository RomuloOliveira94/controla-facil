class AddBalanceToBalance < ActiveRecord::Migration[7.1]
  def change
    add_column :balances, :balance, :decimal
  end
end
