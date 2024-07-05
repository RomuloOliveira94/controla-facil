class DashboardController < ApplicationController
  before_action :authenticate_user!
  include BalanceHelper

  def index; end
end
