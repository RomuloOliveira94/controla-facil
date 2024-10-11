class AddDateToIncomesTable < ActiveRecord::Migration[7.1]
  def change
    add_column :incomes, :date, :date
  end
end
