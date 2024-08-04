class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :total_incomes
  before_action :total_expenses
  before_action :total_balance
  before_action :total_fixed_expenses
  before_action :total_fixed_incomes

  include BalanceHelper

  def index
    @all_incomes_and_expenses = user_actual_month_yeah_balance.all_incomes_and_expenses.sort_by!(&:created_at).reverse
  end

  private

  def total_incomes
    @total_incomes ||= user_actual_month_yeah_balance.try(:incomes)&.sum(:value)
  end

  def total_expenses
    @total_expenses ||= user_actual_month_yeah_balance.try(:expenses)&.sum(:value)
  end

  def total_fixed_expenses
    @total_fixed_expenses ||= user_actual_month_yeah_balance.try(:expenses).where(fixed: true)&.sum(:value)
  end

  def total_fixed_incomes
    @total_fixed_incomes ||= user_actual_month_yeah_balance.try(:incomes).where(fixed: true)&.sum(:value)
  end

  def total_balance
    @total_balance ||= user_actual_month_yeah_balance.try(:balance)
  end
end
