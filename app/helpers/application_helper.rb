module ApplicationHelper
  def format_brl_currency(value)
    number_to_currency(value, unit: 'R$ ', separator: ',', delimiter: '.', precision: 2)
  end

  def format_boolean(value)
    value ? 'Sim' : 'Não'
  end

  def format_date(value)
    value&.strftime('%d/%m/%Y')
  end

  def incomes_categories
    Category.where(cat_sub: 'incomes')
  end

  def expenses_categories
    Category.where(cat_sub: 'expenses')
  end

  def user_theme
    current_user&.theme ? current_user.theme : 'light'
  end
end
