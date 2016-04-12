module UserEmailRegistration
  extend ActiveSupport::Concern

  private

    def create_with_email
      user = User.new(email_create_params)
      authorize user

      if user.save
        UpdateProfilePictureWorker.perform_async(user.id)
        render json: user, serializer: UserSerializer
      else
        render_validation_errors(user)
      end
    end

    def email_create_params
      email_params = record_attributes.permit(:email, :password)
      create_params.merge(email_params)
    end
end
