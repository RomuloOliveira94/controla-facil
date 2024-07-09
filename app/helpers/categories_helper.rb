module CategoriesHelper
  def all_available_categories
    Category.select(:cat_sub).distinct.pluck(:cat_sub)
  end
end
