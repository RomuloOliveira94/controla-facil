module ApplicationHelper
  def format_brl_currency(value)
    number_to_currency(value, unit: 'R$ ', separator: ',', delimiter: '.', precision: 2)
  end

  def format_boolean(value)
    value ? 'Sim' : 'Não'
  end

  def get_date_by_day(day, value)
    date = Date.new(value.year, value.month, day)
    date.strftime('%d/%m/%Y')
  end

  def format_date(value)
    value&.strftime('%d/%m/%Y')
  end

  def user_theme
    current_user&.theme ? current_user.theme : 'light'
  end

  def category_list_icon_color value_type
    value_type == 'incomes' ? 'text-success' : 'text-error'
  end
end
