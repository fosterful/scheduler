# # frozen_string_literal: true
redis_url = Rails.application.credentials.redis_url || ENV['REDIS_URL']

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end
