class ValidationErrorsSerializer
  ERROR_ID = "VALIDATION_ERROR".freeze
  ERROR_STATUS = 422.freeze

  attr_accessor :model

  def initialize(model)
    self.model = model
  end

  def serialize
    { errors: serialize_errors(model.errors) }
  end

  private

    def serialize_errors(errors)
      errors.to_hash.map do |field, messages|
        source = { pointer: "data/attributes/#{field}" }

        messages.map do |message|
          error_hash_for(source, message)
        end
      end.flatten
    end

    def error_hash_for(source, message)
      { id: ERROR_ID, source: source, detail: message, status: ERROR_STATUS }
    end
end
