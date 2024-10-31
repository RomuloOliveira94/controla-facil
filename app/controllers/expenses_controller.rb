class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[show edit update destroy]
  before_action :format_comma_to_dot, only: %i[create update]
  before_action :load_expense_categories, only: %i[new edit create update]

  include BalanceHelper

  def index
    @q = current_user.expenses.includes(:category).order(date: :desc).ransack(params[:q])
    @pagy, @expenses = pagy_countless(@q.result.includes(:category), limit: 15)
  end

  def show; end

  def new
    @expense = current_user.expenses.build
  end

  def edit; end

  def create
    @expense = current_user.expenses.build(expense_params)

    respond_to do |format|
      if @expense.save
        format.html do
          redirect_to root_path(q: {
                                  month_eq: @expense.date.month,
                                  year_eq: @expense.date.year
                                }), flash: { notice: 'Despesa adicionada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :created, location: @expense }
      else
        format.html do
          render :new, status: :unprocessable_entity, flash: { notice: 'Erro ao adicionar a despesa', style: 'error' }
        end
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html do
          redirect_to root_path(q: {
                                  month_eq: @expense.date.month,
                                  year_eq: @expense.date.year
                                }), flash: { notice: 'Despesa atualizada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html do
          render :edit, status: :unprocessable_entity, flash: { notice: 'Erro ao atualizar a despesa', style: 'error' }
        end
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html do
        redirect_to root_path(q: {
                                month_eq: @expense.date.month,
                                year_eq: @expense.date.year
                              }), flash: { notice: 'Despesa removida com sucesso', style: 'success' }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(:value, :description, :fixed, :date, :user_id, :balance_id, :category_id)
  end

  def format_comma_to_dot
    params[:expense][:value] = params[:expense][:value].to_s.gsub('R$', '').gsub(',', '.')
  end

  def load_expense_categories
    @expenses_categories = Category.user_global(current_user).expenses
  end
end
