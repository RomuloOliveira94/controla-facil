class MonthBalanceMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.month_balance_mailer.month_balance_email.subject
  #
  def month_balance_email
    @user = params[:user]
    @month = params[:month]

    mail to: "romuloffall@gmail.com"
  end
end
