module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_user

    def connect
      self.session_user = request.session.id.to_s
    end

  end
  
end
