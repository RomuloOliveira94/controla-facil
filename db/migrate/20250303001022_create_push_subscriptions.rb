class CreatePushSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :push_subscriptions, force: :cascade do |t|
      t.references :user, null: false, index: true
      t.string :endpoint, null: false
      t.string :p256dh, null: false
      t.string :auth, null: false
      t.timestamps

      t.string :user_agent
    end

    add_index :push_subscriptions, :user_agent
  end
end
