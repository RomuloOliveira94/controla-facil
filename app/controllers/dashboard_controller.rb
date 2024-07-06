class DashboardController < ApplicationController
  before_action :authenticate_user!
  include BalanceHelper

  def index
    @balance = @user_actual_month_yeah_balance
  end
end
