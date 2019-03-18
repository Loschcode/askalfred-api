module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_identity

    def connect
      reject_unauthorized_connection unless authenticated?
    end

    def authenticated?
      if current_identity
        true
      else
        raise Exception, "You must be logged-in to access this section"
      end
    end

    def current_identity
      @current_identity ||= begin
        Identity.find_by_token current_token if current_token
      end
    end

    def current_token
      request.params[:token]
    end
  end
end
