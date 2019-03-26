Rails.application.routes.draw do
  default_url_options :host => "http://localhost:8081"

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  root to: 'index#show'
end
