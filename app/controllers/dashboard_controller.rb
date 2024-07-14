class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :total_incomes
  before_action :total_expenses
  before_action :total_balance
  before_action :all_incomes_and_expenses

  include BalanceHelper

  def index; end

  private

  def total_incomes
    @total_incomes ||= user_actual_month_yeah_balance.try(:incomes)&.sum(:value)
  end

  def total_expenses
    @total_expenses ||= user_actual_month_yeah_balance.try(:expenses)&.sum(:value)
  end

  def total_balance
    if total_incomes.nil? || total_expenses.nil?
      @total_balance = 0
      return
    end

    @total_balance ||= total_incomes - total_expenses
  end

  def all_incomes_and_expenses
    if user_actual_month_yeah_balance.nil?
      @all_incomes_and_expenses = []
      return
    end


    @all_incomes_and_expenses ||= user_actual_month_yeah_balance.try(:incomes) + user_actual_month_yeah_balance.try(:expenses)

    @all_incomes_and_expenses.sort_by!(&:created_at).reverse!
  end
end
