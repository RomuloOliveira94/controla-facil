class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :create_monthly_balance_if_needed

  private

  def create_monthly_balance_if_needed
    return unless user_signed_in? && current_user.balances.where(month: Time.now.mon, year: Time.now.year).empty?

    MonthlyBalanceService.new(current_user, Time.now.mon, Time.now.year).generate_monthly_balance
  end
end
