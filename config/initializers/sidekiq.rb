require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_client do |config|
  # Redis connection
  config.redis = { url: 'redis://redis:6379/12', namespace: 'letsintegrate' }
end

Sidekiq.configure_server do |config|
  # Redis connection
  config.redis = { url: 'redis://redis:6379/12', namespace: 'letsintegrate' }
end

Sidekiq.set_schedule('send_reminder', {
  every: ['1h'],
  class: 'ReminderWorker'
})
