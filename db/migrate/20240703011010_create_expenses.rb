class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.decimal :value
      t.string :description
      t.boolean :fixed
      t.date :date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
