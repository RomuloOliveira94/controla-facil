class ConfigurationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @incomes_categories = Category.user_global(current_user).incomes
    @expenses_categories = Category.user_global(current_user).expenses
    @user = current_user
  end

  def change_theme
    @user = current_user
    @user.theme = configuration_params[:theme]
    @user.save
  end

  def change_email_notifications
    @user = current_user
    email_notifications_value = configuration_params[:email_notifications] == '1'
    @user.email_notifications = email_notifications_value
    @user.save

    respond_to do |format|
      format.json { render json: { status: 'success', email_notifications: @user.email_notifications } }
      format.html { redirect_to configurations_path, notice: 'Configuração de notificações atualizada com sucesso!' }
    end
  end

  def change_push_notifications
    @user = current_user
    push_notifications_value = configuration_params[:push_notifications] == '1'
    @user.push_notifications = push_notifications_value
    @user.save

    respond_to do |format|
      format.json { render json: { status: 'success', push_notifications: @user.push_notifications } }
      format.html do
        redirect_to configurations_path, notice: 'Configuração de notificações push atualizada com sucesso!'
      end
    end
  end

  private

  def configuration_params
    params.require(:configuration).permit(:theme, :email_notifications, :push_notifications)
  end
end
