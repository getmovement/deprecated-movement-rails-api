require "movement_api/base64_image_decoder"

class UpdateProfilePictureWorker
  include Sidekiq::Worker

  attr_reader :user

  def perform(user_id)
    @user = User.find(user_id)

    if user.base_64_photo_data.present?
      update_from_photo_data
    elsif user.facebook_id.present? && user.facebook_access_token.present?
      update_from_facebook
    end
  end

  private

    def update_from_photo_data
      user.photo = Base64ImageDecoder.decode(user.base_64_photo_data)
      user.base_64_photo_data = nil
      user.save
    end

    def update_from_facebook
      photo_url = FacebookService.from_user(user).profile_photo
      return unless photo_url
      user.photo = URI.parse(photo_url)
      user.save
    end
end
