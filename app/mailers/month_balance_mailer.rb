class MonthBalanceMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.month_balance_mailer.month_balance_email.subject
  #
  def month_balance_email
    @greeting = 'Olá'
    @user = params[:user]
    @balance = params[:balance]
    @month = I18n.t('date.month_array')[Date.today.prev_month.month]
    @year = Date.today.prev_month.year
    @total_incomes = format_brl_currency(params[:total_incomes] || 0)
    @total_expenses = format_brl_currency(params[:total_expenses] || 0)
    @total_balance = format_brl_currency(@balance.balance || 0)

    @formatted_incomes = @balance.incomes.collect do |income|
      {
        value: format_brl_currency(income.value),
        date: income.created_at.strftime('%d/%m/%Y'),
        description: income.description
      }
    end

    @formatted_expenses = @balance.expenses.collect do |expense|
      {
        value: format_brl_currency(expense.value),
        date: expense.created_at.strftime('%d/%m/%Y'),
        description: expense.description
      }
    end

    mail to: @user.email, subject: "Balanço financeiro do mês de #{@month}/#{@year} - Controla Fácil"
  end

  def format_brl_currency(value)
    ActionController::Base.helpers.number_to_currency(value, unit: 'R$ ', separator: ',', delimiter: '.', precision: 2)
  end
end
