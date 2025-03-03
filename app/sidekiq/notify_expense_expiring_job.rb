class NotifyExpenseExpiringJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  def perform(*_args)
    User.all.each do |user|
      next unless user.push_subscription.present?

      expenses = user.expenses.where(date: Time.zone.now.beginning_of_day..3.days.from_now.end_of_day)

      expenses.each do |expense|
        formatted_date = I18n.l(expense.date, format: '%A, %d de %B de %Y')
        WebPushService.new(title: '📅 Vencimento de Despesa!',
                           message: "💸 #{expense.description} vai vencer #{formatted_date} 🎴",
                           target: user).call
      end
    end
  end
end
