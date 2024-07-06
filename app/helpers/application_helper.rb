module ApplicationHelper

  def format_brl_currency(value)
    number_to_currency(value, unit: "R$ ", separator: ",", delimiter: ".", precision: 2)
  end

  def format_boolean(value)
    value ? "Sim" : "Não"
  end
end
