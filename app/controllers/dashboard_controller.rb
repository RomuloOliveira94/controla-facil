class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :total_incomes
  before_action :total_expenses
  before_action :total_balance
  
  include BalanceHelper

  def index; end

  private

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
