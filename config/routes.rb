require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options host: ENV['APP_URL']

  mount Sidekiq::Web => '/sidekiq'

  ActiveAdmin.routes(self)

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
  end

  post '/graphql', to: 'graphql#execute'
  root to: 'index#show'
end
