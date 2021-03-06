require 'sidekiq/web'

Rails.application.routes.draw do
  default_url_options host: ENV['APP_URL']

  mount Sidekiq::Web => '/sidekiq'
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?

  ActiveAdmin.routes(self)

  post '/graphql', to: 'graphql#execute'
  root to: 'index#show'

  resource :open, only: [], controller: 'open' do
    post :create_guest
  end

  namespace :webhooks do
    namespace :mailgun do
      resource :incoming
    end
    namespace :stripe do
      resource :events
    end
  end
end
