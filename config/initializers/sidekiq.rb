Sidekiq.configure_server do |config|
  config.redis = { size: 9, url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1, url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
end
