class PushSubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    subscription = find_or_initialize_subscription

    if subscription.new_record? || subscription_changed?(subscription)
      subscription.update!(push_subscription_params.merge(user_agent: request.user_agent))
    else
      subscription.touch
    end

    render json: { status: 'success' }, status: :ok
  end

  private

  def find_or_initialize_subscription
    PushSubscription.where(user_id: push_subscription_params[:user_id]).first_or_initialize do |sub|
      sub.endpoint = push_subscription_params[:endpoint]
      sub.p256dh = push_subscription_params[:p256dh]
      sub.auth = push_subscription_params[:auth]
      sub.user_agent = request.user_agent
    end
  end

  def subscription_changed?(subscription)
    subscription.endpoint != push_subscription_params[:endpoint] ||
      subscription.p256dh != push_subscription_params[:p256dh] ||
      subscription.auth != push_subscription_params[:auth] ||
      subscription.user_agent != request.user_agent
  end

  def push_subscription_params
    params.require(:push_subscription).permit(:endpoint, :p256dh, :auth, :user_id)
  end
end
