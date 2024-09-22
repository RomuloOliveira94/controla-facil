Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_SERVER_URL'], password: ENV['REDIS_SERVER_PASSWORD'] || '' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_CLIENT_URL'], password: ENV['REDIS_CLIENT_PASSWORD'] || '' }
end

Sidekiq.strict_args!(false)
