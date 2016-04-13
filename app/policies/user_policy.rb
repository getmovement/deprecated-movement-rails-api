class UserPolicy < ApplicationPolicy
  alias user record

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
