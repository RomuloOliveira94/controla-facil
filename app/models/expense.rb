class Expense < ApplicationRecord
  belongs_to :user
  belongs_to :balance
  include ConvertValue

  before_save :convert_float

  private

  def convert_float
    self.value = convert_value(self.value)
  end
end
