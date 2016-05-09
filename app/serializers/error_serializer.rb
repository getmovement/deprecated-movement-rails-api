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

    # Figures out the serialization method name from the error class name
    # ModuleName::ClassName -> :serialize_module_name_class_name
    #
    # The main #serialize method then sends this method name to the class instance
    # If the serializer doesn't support serializing that error class, a "method_missing"
    # error will be raised
    def serialization_method
      # ModuleName::ClassName -> "ModuleName/ClassName"
      full_error_class_name = error.class.to_s
      # "ModuleName/ClassName" -> "module_name_class_name"
      underscored_full_error_class_name = full_error_class_name.underscore.tr("/", "_")
      # "module_name_class_name" -> :serialize_module_name_class_name
      "serialize_#{underscored_full_error_class_name}".to_sym
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
