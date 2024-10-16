module SetBalance
  extend ActiveSupport::Concern

  included do
    before_validation :set_balance
  end

  def set_balance
    return unless date.present?

    @value_date = date
    self.balance = user.balances.find_by(month: @value_date.month, year: @value_date.year)
    return unless balance.nil?

    generate_new_balance
  end

  def generate_new_balance
    MonthlyBalanceService.new(user, @value_date.month, @value_date.year).generate_monthly_balance
    self.balance = user.balances.find_by(month: @value_date.month, year: @value_date.year)
  end
end
