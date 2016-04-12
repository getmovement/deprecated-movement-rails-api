# Since this concern overrides the default controller create method, it needs
# to be prepended into the controller, instead of being included
module UserFacebookRegistration
  extend ActiveSupport::Concern

  private

    def create_with_facebook
      user = user_from_facebook

      if user.update(facebook_create_params)
        UpdateProfilePictureWorker.perform_async(user.id)
        AddFacebookFriendsWorker.perform_async(user.id)
        render json: user
      else
        render_validation_errors(user)
      end
    end

    def user_from_facebook
      facebook_id = facebook_create_params[:facebook_id]
      email = facebook_create_params[:email]

      User.where(facebook_id: facebook_id, email: email).first_or_create
    end

    def facebook_create_params
      facebook_params = record_attributes.permit(
        :email, :password, :facebook_id, :facebook_access_token)
      create_params.merge(facebook_params)
    end

    def registering_through_facebook?
      facebook_create_params[:facebook_id].present? &&
        facebook_create_params[:facebook_access_token].present?
    end

    def photo_provided?
      facebook_create_params[:base64_photo_data].present?
    end
end
