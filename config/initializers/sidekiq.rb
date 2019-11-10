require 'sidekiq/web'

Dir[Rails.root.join('app', 'workers', '**/*.rb')].each { |file| require file }

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

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [
    ENV['ADMIN_USER'],
    ENV['ADMIN_PASSWORD']
  ]
end