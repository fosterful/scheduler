# # frozen_string_literal: true
credentials = Rails.application.credentials.redis[Rails.env.to_sym] || {}

def build_redis_url(redis_config)
  "redis://#{redis_config[:host]}:#{redis_config[:port]}/#{redis_config[:db_num]}"
end

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: build_redis_url(credentials))
end

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: build_redis_url(credentials))
end