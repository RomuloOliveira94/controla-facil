module UpdateBalanceValue
  extend ActiveSupport::Concern

  included do
    attr_accessor :original_date

    before_save :store_original_date
    after_save :update_balance_value
    after_destroy :update_balance_value
  end

  def store_original_date
    self.original_date = date_was
  end

  def update_balance_value
    update_balance_for_date(original_date) if original_date.present?
    update_balance_for_date(date)
  end

  private

  def update_balance_for_date(date)
    balance = user.balances.find_by(month: date.month, year: date.year)
    return unless balance

    balance.update(balance: balance.incomes.sum(:value) - balance.expenses.sum(:value))
  end
end
