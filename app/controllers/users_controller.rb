class UsersController < APIController
  def show
    render json: User.find(params[:id])
  end
end
