class NotifyExpenseExpiringJob < ApplicationJob
  queue_as :default

  def perform
    today = Time.zone.today
    end_date = [today + 3.days, today.end_of_month].min

    User.joins(:push_subscription).includes(:push_subscription).find_each do |user|
      expenses = user.expenses.where(date: today..end_date)

      expenses.each do |expense|
        formatted_date = I18n.l(expense.date, format: '%A, %d de %B de %Y')
        WebPushService.new(title: '📅 Vencimento de Despesa!',
                           message: "💸 #{expense.description} vai vencer #{formatted_date} 🎴",
                           target: user).call
      end
    end
  end
end
