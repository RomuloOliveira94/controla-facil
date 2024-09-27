class MonthBalanceMailerPreview < ActionMailer::Preview
  def month_balance_email
    user = User.first
    balance = user.balances.includes(:expenses, :incomes).last
    total_incomes = balance.incomes.sum(:value) if balance.incomes.present?
    total_expenses = balance.expenses.sum(:value) if balance.expenses.present?
    MonthBalanceMailer.with(user:, balance:, total_expenses:, total_incomes:).month_balance_email
  end
end
