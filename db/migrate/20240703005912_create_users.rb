class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.datetime :confirmed_at
      t.string :unconfirmed_email
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
