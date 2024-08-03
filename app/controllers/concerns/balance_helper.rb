module BalanceHelper
  extend ActiveSupport::Concern

  included do
    before_action :user_actual_month_yeah_balance
  end


  def user_actual_month_yeah_balance
    @user_actual_month_yeah_balance ||= current_user.balances.includes(:expenses, :incomes).where(month: Time.now.mon, year: Time.now.year).first
  end
end
