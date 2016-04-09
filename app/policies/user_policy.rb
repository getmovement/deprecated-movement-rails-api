class UserPolicy
  attr_reader :current_user, :user

  def initialize(current_user, user)
    @current_user = current_user
    @user = user
  end

  def show?
    true
  end

  def create?
    true
  end

  def update_authenticated_user?
    current_user == user
  end

  def forgot_password?
    true
  end

  def reset_password?
    true
  end
end
