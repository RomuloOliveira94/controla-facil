class CreateBalances < ActiveRecord::Migration[7.1]
  def change
    create_table :balances do |t|
      t.integer :month
      t.integer :year
      t.boolean :red
      t.boolean :green
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
