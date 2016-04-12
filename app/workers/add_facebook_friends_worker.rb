class AddFacebookFriendsWorker
  include Sidekiq::Worker

  def perform(user_id)
    user = User.find(user_id)
    facebook_friend_ids = FacebookService.from_user(user).facebook_friend_ids
    add_friends(facebook_friend_ids, user)
  end

  def add_friends(facebook_friend_ids, user)
    facebook_friend_ids.each do |facebook_id|
      friend = User.find_by(facebook_id: facebook_id)
      if friend
        friend.follow(user) unless friend.following?(user)
        user.follow(friend) unless user.following?(friend)
      end
    end
  end
end
