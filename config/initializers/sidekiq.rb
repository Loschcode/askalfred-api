Sidekiq.configure_server do |config|
  config.redis = {
    id: nil,
    url: ENV['REDIS_URL'] || 'redis://localhost:6379/1'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    id: nil,
    url: ENV['REDIS_URL'] || 'redis://localhost:6379/1'
  }
end

schedule_file = 'config/schedule.yml'
if File.exists?(schedule_file) # && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
