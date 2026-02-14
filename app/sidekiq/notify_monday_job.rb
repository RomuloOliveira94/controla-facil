class NotifyMondayJob
  include Sidekiq::Job
  sidekiq_options retry: 0

  MESSAGES = [
    'Que sua semana comece com muita energia! 💪',
    'Segunda-feira é um novo começo, aproveite! 🌟',
    'Vamos começar a semana com o pé direito! 👣',
    'Que sua segunda-feira seja produtiva e cheia de conquistas! 🏆',
    'Segunda-feira é dia de novos desafios, você consegue! 🚀',
    'Uma ótima segunda-feira para você! 😊',
    'Que sua semana seja incrível, começando por hoje! ✨',
    'Segunda-feira é dia de recomeçar, vamos lá! 🔄',
    'Desejo uma segunda-feira cheia de sucesso para você! 🎉',
    'Que sua segunda-feira seja tão maravilhosa quanto você! 🌈'
  ].freeze

  def perform(*_args)
    User.joins(:push_subscription).includes(:push_subscription).find_each do |user|
      WebPushService.new(title: '🌟 Uma nova semana começa!',
                         message: MESSAGES.sample,
                         target: user).call
    end
  end
end
