class CreateIncomes < ActiveRecord::Migration[7.1]
  def change
    create_table :incomes do |t|
      t.decimal :value
      t.string :description
      t.boolean :fixed
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
