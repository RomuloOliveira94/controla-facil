class MonthBalanceMailerPreview < ActionMailer::Preview
  def month_balance_email
    user = User.first
    balance = user.balances.last
    MonthBalanceMailer.with(user:, balance:).month_balance_email
  end
end
