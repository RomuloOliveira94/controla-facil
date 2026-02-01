class ChangeProviderTokenColumnTypeFromUser < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :provider_token, :text
  end
end
