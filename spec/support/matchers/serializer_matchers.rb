RSpec::Matchers.define :serialize_object do |object|
  chain :with do |serializer_klass|
    @serializer_klass = serializer_klass
  end

  chain :with_includes do |includes|
    @includes = Array.wrap(includes)
  end

  # AMS with the JSON_API adapter deep-transforms the resulting has keys
  # the default transformation is dasherization, but it's also possible to
  # specify a method, so this chaing gives us an option to to the same when
  # checking the result
  chain :with_key_transform do |key_transform_method|
    @key_transform_method = key_transform_method
  end

  match do |actual_json|
    @object = object
    @actual_json = actual_json
    @expected_json = serialize(object)
    expected == actual
  end

  def includes
    @includes ||= []
  end

  def key_transform_method
    @key_transform_method ||= :dashed
  end

  def transform_keys(hash)
    ActiveModelSerializers::KeyTransform.send(key_transform_method, hash)
  end

  def serialize(object)
    serializer = @serializer_klass.new(object)
    serialization = ActiveModelSerializers::Adapter.create(serializer, include: includes)
    transform_keys(serialization.as_json).with_indifferent_access
  end

  def expected
    @expected_json
  end

  def actual
    @actual_json
  end

  def failure_message
    "expected json to be a result of serializing #{@object} with #{@serializer_klass}"
  end

  diffable
end

RSpec::Matchers.define :serialize_collection do |collection|
  chain :with do |serializer_klass|
    @serializer_klass = serializer_klass
  end

  chain :with_includes do |includes|
    @includes = Array.wrap(includes)
  end

  chain :with_meta do |meta|
    @meta = meta
  end

  chain :with_links_to do |host|
    @host = host
  end

  # AMS with the JSON_API adapter deep-transforms the resulting has keys
  # the default transformation is dasherization, but it's also possible to
  # specify a method, so this chaing gives us an option to to the same when
  # checking the result
  chain :with_key_transform do |key_transform_method|
    @key_transform_method = key_transform_method
  end

  match do |actual_json|
    @collection = collection
    @actual_json = cleanup(actual_json)
    @expected_json = serialize(collection)

    content_ok? && remainder_ok?
  end

  def serialize(collection)
    options = {}
    options = options.merge(pagination_options) if paginated?(collection)
    serializer =  ActiveModel::Serializer::CollectionSerializer.new(
      collection, serializer: @serializer_klass)
    serialization = ActiveModelSerializers::Adapter.create(
      serializer, include: includes, meta: meta)

    expected_json = serialization.as_json(options)
    expected_json = cleanup(expected_json)
    transform_keys(expected_json).with_indifferent_access
  end

  def key_transform_method
    @key_transform_method ||= :dashed
  end

  def transform_keys(hash)
    ActiveModelSerializers::KeyTransform.send(key_transform_method, hash)
  end

  def includes
    @includes ||= []
  end

  attr_reader :meta

  def host
    @host || ""
  end

  def validate_meta?
    @meta.present?
  end

  def validate_links?
    @host.present?
  end

  def cleanup(json)
    json = json.with_indifferent_access
    json = json.except(:meta) unless validate_meta?
    json = json.except(:links) unless validate_links?
    json
  end

  def paginated?(collection)
    collection.respond_to?(:current_page) &&
      collection.respond_to?(:total_pages) &&
      collection.respond_to?(:size)
  end

  def pagination_options
    request = double(original_url: host, query_parameters: {})

    serialization_context = ActiveModelSerializers::SerializationContext.new(request)

    { serialization_context: serialization_context }
  end

  def arrays_have_same_elements(a, b)
    a.to_set == b.to_set
  end

  def content_ok?
    arrays_have_same_elements(expected[:data], actual[:data])
  end

  # ensures parts of the json objects other than the :data hash are also identical
  def remainder_ok?
    expected.delete(:data)
    actual.delete(:data)
    expected == actual
  end

  def expected
    @expected_json
  end

  def actual
    @actual_json
  end

  def failure_message
    "expected json to be a result of serializing #{@collection} with #{@serializer_klass}"
  end

  diffable
end
