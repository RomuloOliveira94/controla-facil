class DashboardController < ApplicationController
  include BalanceHelper
  before_action :authenticate_user!
  def index; end
end
