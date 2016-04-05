class UsersController < APIController
  include UserPasswordManagement
  prepend UserFacebookRegistration

  before_action :doorkeeper_authorize!, only: [:update_authenticated_user]

  def show
    user = User.find(params[:id])
    authorize user

    render json: User.find(params[:id])
  end

  def create
    user = User.new(create_params)

    authorize user

    if user.save
      render json: user, serializer: UserSerializer
    else
      render_validation_errors(user)
    end
  end

  def update_authenticated_user
    update_and_render_result current_user
  end

  private

    def create_params
      record_attributes.permit(:email, :password, :first_name, :last_name)
    end

    def update_params
      record_attributes.permit(:first_name, :last_name, :base_64_photo_data)
    end

    def update_and_render_result(user)
      user.assign_attributes update_params

      if user.save
        UpdateProfilePictureWorker.perform_async(user.id)
        render json: user
      else
        render_validation_errors(user.errors)
      end
    end
end
