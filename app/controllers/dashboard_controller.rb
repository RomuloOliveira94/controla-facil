class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search

  include BalanceHelper

  def index
    @result = @q.result.includes(expenses: :category, incomes: :category).order(created_at: :desc).first

    if @result
      @all_incomes_and_expenses = @result.all_incomes_and_expenses if @result
      @total_incomes = total_incomes
      @total_expenses = total_expenses
      @total_balance = total_balance
      @total_fixed_expenses = total_fixed_expenses
      @total_fixed_incomes = total_fixed_incomes
    end

    @month = @q.month_eq
    @year = @q.year_eq
  end

  private

  def set_search
    if params[:q].blank?
      params[:q] = {
        month_eq: Time.now.mon,
        year_eq: Time.now.year
      }
    end
    @q = current_user.balances.ransack(params[:q])
  end

  def total_incomes
    @total_incomes ||= @result.try(:incomes)&.sum(:value)
  end

  def total_expenses
    @total_expenses ||= @result.try(:expenses)&.sum(:value)
  end

  def total_fixed_expenses
    @total_fixed_expenses ||= @result.try(:expenses).where(fixed: true)&.sum(:value)
  end

  def total_fixed_incomes
    @total_fixed_incomes ||= @result.try(:incomes).where(fixed: true)&.sum(:value)
  end

  def total_balance
    @total_balance ||= @result.try(:balance)
  end
end
