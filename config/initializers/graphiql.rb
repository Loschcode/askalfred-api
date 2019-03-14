# fake token for development
GraphiQL::Rails.config.headers['token'] = -> (context) { Identity.first.token }