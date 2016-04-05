class FacebookService
  attr_reader :user, :graph

  def self.from_user(user)
    new(token: user.facebook_access_token)
  end

  def self.from_token(token)
    new(token: token)
  end

  def initialize(token: nil)
    @graph = Koala::Facebook::API.new(token, ENV["FACEBOOK_APP_SECRET"])
  end

  def profile_photo(type: "large")
    graph.get_picture("me", type: type)
  end

  def facebook_id
    facebook_user = graph.get_object("me", fields: %w(email first_name last_name))
    facebook_user["id"]
  end
end
