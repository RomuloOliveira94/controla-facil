class NotifyMonthBeginJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  MESSAGES = [
    '💡 Não esqueça de registrar suas despesas e receitas!',
    '📊 Mantenha suas finanças em dia neste novo mês!',
    '📅 Um novo mês começa, organize suas finanças!',
    '💰 Controle suas despesas e receitas para um mês tranquilo!',
    '📈 Não perca o controle das suas finanças neste mês!',
    '📝 Registre suas despesas e receitas para um melhor planejamento!',
    '💸 Fique de olho nas suas finanças neste novo mês!',
    '📆 Comece o mês com suas finanças organizadas!',
    '💵 Não se esqueça de anotar suas despesas e receitas!',
    '📂 Mantenha suas finanças em ordem neste novo mês!'
  ].freeze

  def perform(*_args)
    User.joins(:push_subscription).includes(:push_subscription).find_each do |user|
      WebPushService.new(title: '📅 Começa um mês novo!',
                         message: MESSAGES.sample,
                         target: user).call
    end
  end
end
