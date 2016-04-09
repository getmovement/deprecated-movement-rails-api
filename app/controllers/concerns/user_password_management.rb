module UserPasswordManagement
  extend ActiveSupport::Concern

  included do
    skip_before_action do
      load_and_authorize_resource param_method: :reset_password_params, only: [:reset_password]
    end
  end

  def forgot_password
    authorize User

    user = User.find_by(email: forgot_password_params[:email])

    if user && user.forgot_password!
      render json: user
    else
      render_no_such_email_error(user)
    end
  end

  def reset_password
    authorize User

    user = find_user_by_confirmation_token

    if user && user.update_password(reset_password_params[:password])
      render json: user
    else
      render_could_not_reset_password_error(user)
    end
  end


  private
    def forgot_password_params
      record_attributes.permit(:email)
    end

    def reset_password_params
      record_attributes.permit(:confirmation_token, :password)
    end

    def find_user_by_confirmation_token
      User.find_by(confirmation_token: reset_password_params[:confirmation_token])
    end

    def render_no_such_email_error(user)
      render_custom_validation_errors(user || User.new, :email, "doesn't exist in the database")
    end

    def render_could_not_reset_password_error(user)
      render_custom_validation_errors(user || User.new, :password, "could not be reset")
    end

    def render_custom_validation_errors(user, field, message)
      user.errors.add(field, message)
      render_validation_errors(user)
    end

end
