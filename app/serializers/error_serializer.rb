class ErrorSerializer
  attr_accessor :error

  def initialize(error)
    self.error = error
  end

  def serialize
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
end
