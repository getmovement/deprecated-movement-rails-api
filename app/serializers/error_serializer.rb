class ErrorSerializer
  attr_accessor :error

  def initialize(error)
    self.error = error
  end

  def serialize
    error_hash = send(serialization_method)
    { errors: Array.wrap(error_hash) }
  end

  private

    def serialization_method
      error.class.to_s.underscore.tr("/", "_").prepend("serialize_").to_sym
    end

    def serialize_active_record_record_not_found
      {
        id: "RECORD_NOT_FOUND",
        title: "Record not found",
        detail: error.message,
        status: 404
      }
    end

    def serialize_doorkeeper_o_auth_invalid_token_response
      {
        id: "NOT_AUTHORIZED",
        title: "Not authorized",
        detail: error.description,
        status: 401
      }
    end

    def serialize_doorkeeper_o_auth_error_response
      {
        id: "INVALID_GRANT",
        title: "Invalid grant",
        detail: error.description,
        status: 401
      }
    end

    def serialize_koala_facebook_authentication_error
      {
        id: "FACEBOOK_AUTHENTICATION_ERROR",
        title: "Facebook authentication error",
        detail: error.fb_error_message,
        status: error.http_status
      }
    end
end
