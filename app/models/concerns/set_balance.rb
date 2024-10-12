module SetBalance
  extend ActiveSupport::Concern

  included do
    before_validation :set_balance
  end

  def set_balance
    return unless date.present?

    @expense_date = date
    self.balance = user.balances.find_by(month: @expense_date.month, year: @expense_date.year)
    return unless balance.nil?

    generate_new_balance
  end

  def generate_new_balance
    MonthlyBalanceService.new(user, @expense_date.month, @expense_date.year).generate_monthly_balance
    self.balance = user.balances.find_by(month: @expense_date.month, year: @expense_date.year)
  end
end
