class IncomesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_income, only: %i[show edit update destroy]
  before_action :format_comma_to_dot, only: %i[create update]
  before_action :load_income_categories, only: %i[new edit create update]
  include BalanceHelper

  def index
    @q = current_user.incomes.includes(:category).order(date: :desc).ransack(params[:q])
    @pagy, @incomes = pagy_countless(@q.result.includes(:category), limit: 15)
  end

  def show; end

  def new
    @income = current_user.incomes.build
  end

  def edit; end

  def create
    @income = current_user.incomes.build(income_params)
    @income.balance_id = @user_actual_month_yeah_balance.id

    respond_to do |format|
      if @income.save
        format.html do
          redirect_to root_path(q: {
                                  month_eq: @income.date.month,
                                  year_eq: @income.date.year
                                }), flash: { notice: 'Receita adicionada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :created, location: @income }
      else
        format.html do
          render :new, status: :unprocessable_entity, flash: { notice: 'Erro ao adicionar a receita', style: 'error' }
        end
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if params[:fixed] == false
      @income.day = nil
      @income.save
    end

    respond_to do |format|
      if @income.update(income_params)
        format.html do
          redirect_to root_path(q: {
                                  month_eq: @income.date.month,
                                  year_eq: @income.date.year
                                }), flash: { notice: 'Receita atualizada com sucesso', style: 'success' }
        end
        format.json { render :show, status: :ok, location: @income }
      else
        format.html do
          render :edit, status: :unprocessable_entity, flash: { notice: 'Erro ao atualizar a receita', style: 'error' }
        end
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @income.destroy!

    respond_to do |format|
      format.html do
        redirect_to root_path(q: {
                                month_eq: @income.date.month,
                                year_eq: @income.date.year
                              }), flash: { notice: 'Receita removida com sucesso', style: 'success' }
      end
      format.json { head :no_content }
    end
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:value, :description, :fixed, :user_id, :balance_id, :category_id, :day, :date)
  end

  def format_comma_to_dot
    params[:income][:value] = params[:income][:value].to_s.gsub('R$', '').gsub(',', '.')
  end

  def load_income_categories
    @incomes_categories = Category.user_global(current_user).incomes
  end
end
