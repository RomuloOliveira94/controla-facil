class NotifyFridayJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  MESSAGES = [
    'Aproveite o final de semana com controle! 📊',
    'Sextou! Não esqueça de planejar suas finanças. 💰',
    'Final de semana chegou! Que tal revisar seu orçamento? 📈',
    'Sextou! Lembre-se de economizar para o futuro. 🏦',
    'Aproveite o final de semana e controle seus gastos! 💳',
    'Sextou! Mantenha suas finanças em dia. 📅',
    'Final de semana é ótimo para organizar suas contas. 📂',
    'Sextou! Não gaste mais do que pode. 💸',
    'Aproveite o final de semana e faça um balanço financeiro. 📊',
    'Sextou! Controle suas despesas e tenha um ótimo final de semana. 🏖️'
  ].freeze

  def perform(*_args)
    User.all.each do |user|
      next unless user.push_subscription.present?

      WebPushService.new(title: "Sextou! #{user.first_name.camelize} 🎉",
                         message: MESSAGES.sample,
                         target: user).call
    end
  end
end
