class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :create_monthly_balance_if_needed

  private

  def create_monthly_balance_if_needed
    return unless user_signed_in? && current_user.balances.where(month: Time.now.mon, year: Time.now.year).empty?

    if current_user.balances.empty?
      current_user.balances.create(month: Time.now.mon, year: Time.now.year, balance: 0)
    else
      MonthlyBalanceService.new(current_user, Time.now.mon, Time.now.year).generate_monthly_balance
    end
  end
end
