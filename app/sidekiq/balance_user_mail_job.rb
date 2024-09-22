class BalanceUserMailJob
  include Sidekiq::Job
  sidekiq_options retry: 1

  def perform(*_args)
    users = User.all

    users.each do |user|
      last_month_date = Date.today.prev_month
      last_month = last_month_date.month
      last_month_year = last_month_date.year

      last_month_balance = user.balances.find_by(month: last_month, year: last_month_year)

      if last_month_balance.present?
        MonthBalanceMailer.with(user:,
                                balance: last_month_balance).month_balance_email.deliver_now
      end

      NoBalanceMailer.with(user:).no_balance_mail.deliver_now if last_month_balance.nil?
    end
  end
end
