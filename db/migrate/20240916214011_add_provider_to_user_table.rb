class AddProviderToUserTable < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :provider, :string, null: true
    add_column :users, :provider_token, :string, null: true
  end
end
