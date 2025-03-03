class WebPushService < ApplicationService
  attr_reader :title, :message, :target

  def initialize(title:, message:, target:)
    super()
    @title = title
    @message = message
    @target = target
  end

  def call
    WebPush.payload_send(
      message: message_json,
      endpoint: @target.push_subscription.endpoint,
      p256dh: @target.push_subscription.p256dh,
      auth: @target.push_subscription.auth,
      vapid: vapid
    )
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
