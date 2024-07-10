module CategoriesHelper
  def all_available_categories
    Category.select(:cat_sub).distinct.pluck(:cat_sub).map do |cat_sub|
      case cat_sub
      when 'expenses'
        %w[Despesas expenses]
      when 'incomes'
        %w[Receitas incomes]
      end
    end
  end
end
