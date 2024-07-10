class AddFixedToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :fixed, :boolean, default: false
  end
end
