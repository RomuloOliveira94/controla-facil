require 'test_helper'
require 'minitest/mock'

# Fumaça dos jobs de notificação. O WebPushService captura StandardError e só
# registra no log, então perform_now não levanta mesmo sem push real; o que
# estes testes protegem é a consulta que seleciona os usuários e o fato de os
# jobs rodarem sem argumentos.
class NotificationJobsTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
  include ActionMailer::TestHelper

  setup do
    @com_push = create_user(email: 'com-push@example.com')
    PushSubscription.create!(
      user: @com_push,
      endpoint: 'https://push.example.invalid/endpoint',
      p256dh: 'chave-p256dh',
      auth: 'chave-auth'
    )
    @sem_push = create_user(email: 'sem-push@example.com')
  end

  test 'os jobs de push rodam sem levantar erro' do
    [NotifyFridayJob, NotifyMondayJob, NotifyMonthBeginJob, NotifyExpenseExpiringJob].each do |job|
      assert_nothing_raised { job.perform_now }
    end
  end

  test 'os jobs de push só consideram usuários com inscrição' do
    entregues = []
    envio_falso = Object.new
    def envio_falso.call = nil

    WebPushService.stub(:new, ->(**kwargs) { entregues << kwargs[:target].id and envio_falso }) do
      NotifyFridayJob.perform_now
    end

    assert_includes entregues, @com_push.id
    assert_not_includes entregues, @sem_push.id
  end

  test 'BalanceUserMailJob enfileira e-mail para quem optou por notificações' do
    @com_push.update!(email_notifications: true)
    @sem_push.update!(email_notifications: false)

    assert_enqueued_emails 1 do
      BalanceUserMailJob.perform_now
    end
  end

  test 'BalanceUserMailJob não enfileira nada quando ninguém optou' do
    User.update_all(email_notifications: false)

    assert_no_enqueued_emails do
      BalanceUserMailJob.perform_now
    end
  end
end
