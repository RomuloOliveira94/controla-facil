class ProvidersController < ApplicationController
  def start_google_session
    auth = request.env['omniauth.auth']
    email = auth['info']['email']
    provider_token = auth['credentials']['token']
    user = User.find_by(email:)
    password_digest = BCrypt::Password.create(SecureRandom.hex(10))
    first_name = auth['info']['first_name']
    last_name = auth['info']['last_name']
    provider = auth['provider']

    if user
      user.update(provider_token:, provider:)
    else
      user = User.new(email:, first_name:,
                      last_name:, password_digest:, provider_token:, provider:)
      unless user.save
        flash[:error] = 'There was an error signing in with Google. Please try again.'
        redirect_to root_path and return
      end
    end

    session[:user_id] = user.id

    redirect_to dashboard_path
  end
end
