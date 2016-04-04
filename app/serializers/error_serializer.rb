class ErrorSerializer
  attr_accessor :error

  def initialize(error)
    self.error = error
  end

  def serialize
    error_hash = serialize_doorkeeper_oauth_invalid_token_response(error) if error.class == Doorkeeper::OAuth::InvalidTokenResponse
    error_hash = serialize_record_not_found_error(error) if error.class == ActiveRecord::RecordNotFound
    { errors: Array.wrap(error_hash) }
  end

  private

    def serialize_record_not_found_error(error)
      return {
        id: "RECORD_NOT_FOUND",
        title: "Record not found",
        detail: error.message,
        status: 404
      }
    end

    def serialize_doorkeeper_oauth_invalid_token_response(error)
      return {
        id: "NOT_AUTHORIZED",
        title: "Not authorized",
        detail: error.description,
        status: 401
      }
    end
end
