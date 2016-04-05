class APIController < ActionController::API
  include Clearance::Controller
  include Pundit
  include ErrorResponses
  include JsonApiParameters

  before_action :set_default_response_format

  def current_user
    current_resource_owner
  end

  def signed_in?
    current_user.present?
  end

  def signed_out?
    current_user.nil?
  end

  private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def set_default_response_format
      request.format = :json unless params[:format]
    end
end
