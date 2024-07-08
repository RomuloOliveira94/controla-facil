class ConfigurationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
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
