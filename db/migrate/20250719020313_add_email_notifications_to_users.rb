class AddEmailNotificationsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :email_notifications, :boolean, default: false
  end
end
