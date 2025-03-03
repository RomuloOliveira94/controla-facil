class WebPushService < ApplicationService
  attr_reader :title, :message, :targets

  def initialize(title:, message:, targets:)
    super()
    @title = title
    @message = message
    @targets = targets
  end

  def call
    @targets.each do |target|
      WebPush.payload_send(
        message: message_json,
        endpoint: target.push_subscription.endpoint,
        p256dh: target.push_subscription.p256dh,
        auth: target.push_subscription.auth,
        vapid: vapid
      )
    end
  rescue StandardError => e
    Rails.logger.error(e)
  end

  private

  def message_json
    {
      title: @title,
      body: @message,
      icon: '/favicon.png'
    }.to_json
  end

  def vapid
    {
      subject: "mailto:#{ENV['MAIL_USER']}",
      public_key: Rails.configuration.x.vapid.public_key,
      private_key: Rails.configuration.x.vapid.private_key
    }
  end
end
