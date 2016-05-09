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

  def facebook_friend_ids
    friends = graph.get_connections("me", "friends")
    all_friend_ids(friends)
  end

  private

    def all_friend_ids(friends)
      current_page_of_ids = friends.map { |friend| friend["id"] } if friends.present?
      current_page_of_ids = [] unless friends.present?

      next_page = friends.next_page
      remaining_friend_ids = all_friend_ids(next_page) if next_page.present?
      remaining_friend_ids = [] unless next_page.present?

      current_page_of_ids.concat(remaining_friend_ids)
    end
end
