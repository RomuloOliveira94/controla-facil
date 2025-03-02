Rails.application.routes.draw do
  resources :expenses
  resources :incomes
  resources :categories

  get '/dashboard' => 'dashboard#index', as: :dashboard
  post '/generate_monthly_balance' => 'dashboard#generate_monthly_balance', as: :generate_monthly_balance
  get '/configurations' => 'configurations#index', as: :configurations
  patch '/configurations/change_theme' => 'configurations#change_theme', as: :change_theme

  get '/auth/google_oauth2/callback', to: 'providers#start_google_session'

  get 'service-worker' => 'pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'pwa#manifest', as: :pwa_manifest

  revise_auth

  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'dashboard#index'
end
