class AddPushNotificationsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :push_notifications, :boolean, default: false
  end
end
