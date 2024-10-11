module ApplicationHelper
  include Pagy::Frontend

  def format_brl_currency(value)
    number_to_currency(value, unit: 'R$ ', separator: ',', delimiter: '.', precision: 2)
  end

  def format_boolean(value)
    value ? 'Sim' : 'Não'
  end

  def get_date_by_day(value)
    month = value.created_at.month
    year = value.created_at.year
    date = Date.new(year, month, value.day)
    date.strftime('%d/%m/%Y')
  end

  def format_date(value)
    value&.strftime('%d/%m/%Y')
  end

  def user_theme
    current_user&.theme ? current_user.theme : 'light'
  end

  def category_list_icon_color(value_type)
    value_type == 'incomes' ? 'text-success' : 'text-error'
  end

  def get_month_text(month)
    I18n.t('date.month_array')[month]
  end

  def advance_date(date)
    date.advance(months: 1)
    date
  end

  def decrease_date(date)
    date.advance(months: -1)
    date
  end
end
