class AddDayToIncomes < ActiveRecord::Migration[7.1]
  def change
    add_column :incomes, :day, :integer
  end
end
