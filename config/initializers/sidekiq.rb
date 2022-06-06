# # frozen_string_literal: true

redis_url = Rails.application.credentials.redis_url || ENV['REDIS_URL']

Sidekiq.configure_client do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end

Sidekiq.configure_server do |config|
  config.redis = Sidekiq::RedisConnection.create(namespace: Rails.env, url: redis_url)
end

if Rails.env.production?
  CRONJOBS = [
  {
    'name'  => 'Reminders',
    'class' => 'RemindWorker',
    'cron'  => '0 9-20 * * *',
  },
  {
    'name'  => 'Shift Surveys',
    'class' => 'ShiftSurveyWorker',
    'cron'  => '0 5,20,35,50 * ? * *'
  }]

  Sidekiq::Cron::Job.load_from_array! CRONJOBS
end
