# fake token for development
GraphiQL::Rails.config.headers['token'] = -> (context) { User.first.token }