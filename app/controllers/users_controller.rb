class UsersController < APIController
  include UserPasswordManagement
  include UserFacebookRegistration
  include UserEmailRegistration

  before_action :doorkeeper_authorize!, only: [:update_authenticated_user]

  def show
    user = User.find(params[:id])
    authorize user

    render json: User.find(params[:id])
  end

  def create
    create_with_facebook if registering_through_facebook?
    create_with_email unless registering_through_facebook?
  end

  def update_authenticated_user
    update_and_render_result current_user
  end

  private

    def base_params
      record_attributes.permit(:first_name, :last_name, :base_64_photo_data)
    end

    alias create_params base_params
    alias update_params base_params

    def update_and_render_result(user)
      user.assign_attributes update_params

      if user.save
        UpdateProfilePictureWorker.perform_async(user.id)
        render json: user
      else
        render_validation_errors(user)
      end
    end
end
