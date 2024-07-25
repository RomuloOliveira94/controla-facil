class NewMonthBalanceJob < ApplicationJob
  queue_as :default

  def perform
    User.generate_monthly_balance
  end
end
