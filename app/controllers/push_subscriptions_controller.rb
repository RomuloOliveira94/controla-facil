class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = PushSubscription.find_or_initialize_by(push_subscription_params)
    subscription.touch if subscription.persisted?
    subscription.update!(push_subscription_params.merge(user_agent: request.user_agent)) unless subscription.persisted?

    head :ok
  end

  private

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth, :user_id)
  end
end
