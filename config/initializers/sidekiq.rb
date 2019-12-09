# # frozen_string_literal: true
redis_url = Rails.application.credentials.redis_url || ENV['REDIS_URL']

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end

if Rails.env.production?
  ActiveSupport.on_load(:active_record) do
    unless Sidekiq::Cron::Job.find('Reminders')
      Sidekiq::Cron::Job.create(
        name: 'Reminders', cron: '0 9-20 * * *', class: 'RemindWorker'
      )
    end
  end
end
