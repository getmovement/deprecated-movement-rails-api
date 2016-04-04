class UsersController < APIController
  def show
    render json: User.find(params[:id])
  end

  def create
    user = User.new(create_params)

    if user.save
      render json: user, serializer: UserSerializer
    else
      render_validation_errors(user)
    end
  end

  private
    def create_params
      record_attributes.permit(:email, :password)
    end
end
