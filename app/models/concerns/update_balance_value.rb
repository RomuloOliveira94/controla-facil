module UpdateBalanceValue
  extend ActiveSupport::Concern

  included do
    after_save :update_balance_value
  end

  def update_balance_value
    balance.update(balance: balance.incomes.sum(:value) - balance.expenses.sum(:value))
  end
end
