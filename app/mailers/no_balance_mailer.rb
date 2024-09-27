class NoBalanceMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.no_balance_mailer.no_balance_mail.subject
  #
  def no_balance_mail
    @greeting = 'Olá'
    @month = I18n.t('date.month_array')[Date.today.prev_month.month]
    @year = Date.today.prev_month.year
    @user = params[:user]

    mail to: @user.email
  end
end
