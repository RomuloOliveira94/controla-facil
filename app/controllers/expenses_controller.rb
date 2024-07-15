class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expense, only: %i[show edit update destroy]
  before_action :format_comma_to_dot, only: %i[create update]
  before_action :load_expense_categories, only: %i[new edit create update]

  include BalanceHelper

  # GET /expenses or /expenses.json
  def index
    @expenses = current_user.expenses.all
  end

  # GET /expenses/1 or /expenses/1.json
  def show; end

  # GET /expenses/new
  def new
    @expense = current_user.expenses.build
  end

  # GET /expenses/1/edit
  def edit; end

  # POST /expenses or /expenses.json
  def create
    @expense = current_user.expenses.build(expense_params)
    @expense.balance_id = @user_actual_month_yeah_balance.id

    respond_to do |format|
      if @expense.save
        format.html do
          redirect_to expense_url(@expense), flash: { notice: 'Despesa adicionada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1 or /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html do
          redirect_to expense_url(@expense), flash: { notice: 'Despesa atualizada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1 or /expenses/1.json
  def destroy
    @expense.destroy!

    respond_to do |format|
      format.html do
        redirect_to expenses_url, flash: { notice: 'Despesa removida com sucesso', style: 'success' }
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Expense.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
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
