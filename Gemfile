source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'bcrypt'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'

# Markdown
gem 'redcarpet'

# API communications
gem 'rest-client'

# Upload
gem 'aws-sdk-s3'

# Workers
gem 'sidekiq'

# Slack
gem 'slack-notifier'

# Errors
gem 'sentry-raven'

# Payments
gem 'stripe', '4.21.2'
# Admin
gem 'activeadmin'

# Emailings
gem 'mjml-rails'

# Mixpanel
gem 'mixpanel-ruby'

# Skylight
gem 'skylight'

# Anycable
# gem 'anycable-rails'

# GraphQL
gem 'graphql', '1.9.11'
gem 'graphql-errors'
gem 'graphiql-rails'
gem 'graphql-cache'
gem 'apollo_upload_server', '2.0.0.beta.3'

# dependencies of graphiql
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  gem 'pry-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
