module BalanceHelper
  extend ActiveSupport::Concern

  included do
    before_action :user_actual_month_yeah_balance
    before_action :check_balance
  end


  def user_actual_month_yeah_balance
    @user_actual_month_yeah_balance ||= current_user.balances.includes(:expenses, :incomes).where(month: Time.now.mon, year: Time.now.year).first
  end

  def check_balance
    if user_actual_month_yeah_balance.nil?
      create_balance
    end
  end

  def create_balance
    @balance = Balance.new
    @balance.balance = 0
    @balance.month = Time.now.mon
    @balance.year = Time.now.year
    @balance.user = current_user
    @balance.save
  end

  def total_incomes
    @total_incomes ||= user_actual_month_yeah_balance.incomes.sum(:value)
  end

  def total_expenses
    @total_expenses ||= user_actual_month_yeah_balance.expenses.sum(:value)
  end

  def total_balance
    @total_balance ||= total_incomes - total_expenses
  end
end
