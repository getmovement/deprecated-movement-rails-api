RSpec::Matchers.define :be_a_valid_json_api_error do
  def hash_has_nonempty_error_key?
    return false unless @hash.key? :errors
    return false unless @hash[:errors].class == Array
    return false if @hash[:errors].empty?
    true
  end

  def all_errors_in_hash_are_valid?
    return false unless @hash[:errors].all? { |error| valid? error }
    true
  end

  def valid?(error)
    error = error.with_indifferent_access
    return false unless error.key? :id
    return false unless error.key? :title
    return false unless error.key? :detail
    return false unless error.key? :status
    true
  end

  def id_is_correct
    @hash[:errors].first[:id] == @expected_id
  end

  match do |hash|
    @hash = hash.with_indifferent_access
    result = hash_has_nonempty_error_key? && all_errors_in_hash_are_valid?
    result &&= id_is_correct unless @expected_id.nil?
    result
  end

  chain :with_id do |expected_id|
    @expected_id = expected_id
  end
end

RSpec::Matchers.define :be_a_valid_json_api_validation_error do
  def hash_has_nonempty_error_key?
    return false unless @hash.key? :errors
    return false unless @hash[:errors].class == Array
    return false if @hash[:errors].empty?
    true
  end

  def all_errors_in_hash_are_validation_errors?
    return false unless @hash[:errors].all? { |error| validation_error? error }
    true
  end

  def validation_error?(error)
    error = error.with_indifferent_access
    return false unless error[:id] == "VALIDATION_ERROR"
    return false unless error.key? :source
    return false unless error[:source].key? :pointer
    return false unless error.key? :detail
    return false unless error[:status] == 422
    true
  end

  def hash_contains_error_with_message?(message)
    errors = @hash[:errors]
    errors.any? do |error_hash|
      error_message_for(error_hash) == message
    end
  end

  def hash_contains_errors_with_messages?(messages)
    errors = @hash[:errors]
    messages.each do |message|
      error = errors.detect do |error_hash|
        error_message_for(error_hash) == message
      end

      return false unless error.present?
    end

    true
  end

  def error_message_for(error_hash)
    field = error_hash[:source][:pointer].split("/").last
    detail = error_hash[:detail]
    "#{field} #{detail}"
  end

  match do |hash|
    @hash = hash.with_indifferent_access
    result = hash_has_nonempty_error_key? && all_errors_in_hash_are_validation_errors?
    result &&= hash_contains_error_with_message? @message unless @message.nil?
    result &&= hash_contains_errors_with_messages? @messages unless @messages.nil?
    result
  end

  chain :with_message do |message|
    @message = message
  end

  chain :with_messages do |messages|
    @messages = messages
  end
end

RSpec::Matchers.define :contain_an_error_of_type do |expected_type|
  def there_is_an_error_with_id(expected)
    @errors.any? { |e| e[:id] == expected }
  end

  def there_is_an_error_with_message(expected)
    @errors.any? { |e| e[:detail] == expected }
  end

  match do |hash|
    @errors = hash.with_indifferent_access[:errors].map(&:with_indifferent_access)
    result = there_is_an_error_with_id expected_type
    result &&= there_is_an_error_with_message @expected_message unless @expected_message.nil?
    result
  end

  chain :with_message do |expected_message|
    @expected_message = expected_message
  end
end
