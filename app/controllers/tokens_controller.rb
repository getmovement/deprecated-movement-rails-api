class TokensController < Doorkeeper::TokensController
  include ErrorResponses

  def create
    authenticate_with_facebook if signing_in_with_facebook?
    authenticate_with_credentials if singing_in_regularly?
  rescue Doorkeeper::Errors::DoorkeeperError,
         Doorkeeper::Errors::InvalidGrantReuse,
         Doorkeeper::OAuth::Error,
         Koala::Facebook::AuthenticationError,
         ActiveRecord::RecordNotFound => e
    render_error e
  end

  private

    def signing_in_with_facebook?
      params[:username] == "facebook"
    end

    def singing_in_regularly?
      !signing_in_with_facebook?
    end

    def authenticate_with_credentials
      response = strategy.authorize
      if response.class == Doorkeeper::OAuth::TokenResponse
        handle_authentication_successful response
      elsif response.class == Doorkeeper::OAuth::ErrorResponse
        render_error response
      end
    end

    def handle_authentication_successful(response)
      headers.merge! response.headers
      self.status = response.status

      user_id = response.try(:token).try(:resource_owner_id)
      body = response.body.merge("user_id" => user_id)
      self.response_body = body.to_json
    end

    def authenticate_with_facebook
      user_id = user_id_from_facebook_information
      token_data = generate_token_data(user_id)
      render json: token_data.to_json, status: :ok
    end

    def user_id_from_facebook_information
      facebook_access_token = params["password"]
      facebook_service = FacebookService.from_token(facebook_access_token)
      facebook_id = facebook_service.facebook_id
      User.find_by!(facebook_id: facebook_id).id
    end

    def generate_token_data(user_id)
      doorkeeper_access_token = Doorkeeper::AccessToken.create!(
        application_id: nil,
        resource_owner_id: user_id,
        expires_in: 7200)

      {
        access_token: doorkeeper_access_token.token,
        token_type: "bearer",
        expires_in: doorkeeper_access_token.expires_in,
        user_id: user_id.to_s
      }
    end
end
