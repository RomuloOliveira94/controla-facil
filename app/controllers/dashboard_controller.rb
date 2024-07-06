class DashboardController < ApplicationController
  before_action :authenticate_user!
  include BalanceHelper

  def index
    @balance = @user_actual_month_yeah_balance
    @total_incomes = total_incomes
    @total_expenses = total_expenses
    @total_balance = total_balance
  end
end
