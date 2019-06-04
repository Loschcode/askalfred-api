workers 2
threads 5, 5

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RAILS_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end

lowlevel_error_handler do |ex, env|
  Raven.capture_exception(
    ex,
    message: ex.message,
    extra: { puma: env },
    transaction: 'Puma'
  )
  # note the below is just a Rack response
  [500, {}, ['An error has occurred, and engineers have been informed. Please reload the page. If you continue to have problems, contact support@askalfred.app\n']]
end
