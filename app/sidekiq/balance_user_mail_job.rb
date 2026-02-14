class BalanceUserMailJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  def perform(*_args)
    last_month_date = Date.today.prev_month

    User.where.not(email: [nil, '']).where(email_notifications: true).find_each do |user|
      last_month_balance = user.balances.find_by(month: last_month_date.month, year: last_month_date.year)

      if last_month_balance
        total_incomes = last_month_balance.incomes.sum(:value)
        total_expenses = last_month_balance.expenses.sum(:value)

        MonthBalanceMailer.with(user:,
                                balance: last_month_balance, total_incomes:, total_expenses:).month_balance_email.deliver_later
      else
        NoBalanceMailer.with(user:).no_balance_mail.deliver_later
      end
    end
  end
end
