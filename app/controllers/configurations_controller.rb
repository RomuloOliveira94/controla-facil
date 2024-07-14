class ConfigurationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @incomes_categories = Category.user_global(current_user).incomes
    @expenses_categories = Category.user_global(current_user).expenses
  end

  def change_theme
    @user = current_user
    @user.theme = configuration_params[:theme]
    @user.save
  end

  private

  def configuration_params
    params.require(:configuration).permit(:theme)
  end
end
