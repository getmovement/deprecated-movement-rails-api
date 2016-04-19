require "net/https"

class BatchService
  REST_API_KEY = ENV["BATCH_REST_API_KEY"].freeze
  API_KEY = ENV["BATCH_API_KEY"].freeze

  def initialize(rest_api_key: REST_API_KEY, api_key: API_KEY)
    @rest_api_key = rest_api_key
    @api_key = api_key
  end

  def send_notification(options)
    response = send(options)
    response.body["token"]
  end

  private

    def initialize_request_object(title: nil, message: nil, user_token: nil)
      request = Net::HTTP::Post.new(uri.path, header)
      request.body = message_payload(title: title, message: message, user_token: user_token).to_json
      request
    end

    def initialize_http_object
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      http
    end

    def send(options)
      http = initialize_http_object
      request = initialize_request_object(options)
      http.request(request)
    end

    def header
      { "Content-Type" => "application/json", "X-Authorization" => @rest_api_key }
    end

    def uri
      URI("https://api.batch.com/1.0/#{@api_key}/transactional/send")
    end

    def message_payload(user_token: nil, group: "All", title: nil, message: nil)
      {
        group_id: group,
        recipients: { tokens: [user_token] },
        message: { title: title, body: message }
      }
    end
end
