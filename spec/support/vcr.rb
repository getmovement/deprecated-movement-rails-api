VCR.configure do |c|
  c.cassette_library_dir = Rails.root.join("spec", "vcr")
  c.hook_into :webmock
  c.configure_rspec_metadata!

  # Uncomment for debugging VCR
  # c.debug_logger = File.open("log/test.log", "w")

  c.allow_http_connections_when_no_cassette = false

  c.default_cassette_options = { serialize_with: :psych }

  c.ignore_localhost = true

  c.filter_sensitive_data("<BATCH_API_KEY>") { ENV["BATCH_API_KEY"] }
  c.filter_sensitive_data("<BATCH_REST_API_KEY>") { ENV["BATCH_REST_API_KEY"] }
  c.filter_sensitive_data("<FACEBOOK_APP_ID>") { ENV["FACEBOOK_APP_ID"] }
  c.filter_sensitive_data("<FACEBOOK_APP_SECRET>") { ENV["FACEBOOK_APP_SECRET"] }
end
