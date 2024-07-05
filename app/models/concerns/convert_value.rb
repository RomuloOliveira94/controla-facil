module ConvertValue
  extend ActiveSupport::Concern

  def convert_value(value)
    value.to_s.gsub(',', '.').to_f
  end
end
