require "json"
require "hashie/mash"

module RequestHelpers
  def json
    Hashie::Mash.new JSON.parse(last_response.body)
  end

  def host
    "http://api.lvh.me:3000"
  end

  def authenticated_get(path, args, token)
    get full_path(path), args, authorization_header(token)
  end

  def authenticated_post(path, args, token)
    post full_path(path), args, authorization_header(token)
  end

  def authenticated_put(path, args, token)
    put full_path(path), args, authorization_header(token)
  end

  def authenticated_patch(path, args, token)
    patch full_path(path), args, authorization_header(token)
  end

  def authenticated_delete(path, args, token)
    delete full_path(path), args, authorization_header(token)
  end

  private

    def authorization_header(token)
      { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
    end

    def full_path(path)
      "#{host}/#{path}"
    end
end
