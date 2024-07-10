class AddIconToCategoreis < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :icon, :string
  end
end
