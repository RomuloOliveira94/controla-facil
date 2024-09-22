class BalanceUserMailJob
  include Sidekiq::Job
  sidekiq_options retry: 1

  def perform(*args)
    user = User.find(args[0].to_i)
    month = args[1].to_s

    MonthBalanceMailer.with(user:, month:).month_balance_email.deliver_now
  end
end
