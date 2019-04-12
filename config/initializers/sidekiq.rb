# # frozen_string_literal: true
credentials = Rails.application.credentials.redis || { username: ENV['REDIS_USERNAME'], password: ENV['REDIS_PASSWORD'], host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'], db_num: ENV['REDIS_DB_NUM'] }

def build_redis_url(config)
  "redis://#{config[:username]}:#{config[:password]}@#{config[:host]}:#{config[:port]}/#{config[:db_num]}"
end

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: build_redis_url(credentials))
end

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: build_redis_url(credentials))
end
