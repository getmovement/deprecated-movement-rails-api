require "rails_helper"

describe "Users API" do
  describe "GET/users/:id" do
    it "gets the user" do
      user = create(:user)
      get "#{host}/users/#{user.id}"

      expect(last_response.status).to eq 200
      expect(json).to serialize_object(user).with(UserSerializer)
    end

    it "responds with a 404 when getting non-existing user" do
      get "#{host}/users/fake_id"

      expect(last_response.status).to eq 404
      expect(json).to be_a_valid_json_api_error.with_id "RECORD_NOT_FOUND"
    end
  end

  context "POST /users" do
    context "when registering normally" do
      let(:valid_params) do
        {
          data: {
            type: "users",
            attributes: {
              email: "new@example.com",
              first_name: "Example",
              last_name: "User",
              password: "password"
            }
          }
        }
      end

      it "creates a valid user" do
        post "#{host}/users", valid_params
        expect(last_response.status).to eq 200
        expect(json).to serialize_object(User.last).with(UserSerializer)

        expect(json.data.attributes["first-name"]).to eq "Example"
        expect(json.data.attributes["last-name"]).to eq "User"
      end
    end

    context "with invalid parameters" do
      let(:invalid_params) do
        {
          data: { type: "users", attributes: {} }
        }
      end

      it "fails with a validation error" do
        post "#{host}/users", invalid_params
        expect(last_response.status).to eq 422
        expect(json).to be_a_valid_json_api_validation_error.with_messages(
          [
            "email can't be blank",
            "password can't be blank"
          ])
      end
    end

    context "when registering through Facebook" do
      let(:params) do
        {
          data: {
            type: "users",
            attributes: {
              email: "user@example.com",
              password: "password",
              facebook_id: "test_id",
              facebook_access_token: "test_token"
            }
          }
        }
      end

      it "creates a valid user" do
        post "#{host}/users", params

        expect(last_response.status).to eq 200

        user = User.last

        expect(json).to serialize_object(user).with(UserSerializer)

        expect(user.email).to eq "user@example.com"
        expect(user.facebook_id).to eq "test_id"
        expect(user.facebook_access_token).to eq "test_token"

        # ensure all jobs are fired
        expect(UpdateProfilePictureWorker.jobs.size).to eq 1
        expect(AddFacebookFriendsWorker.jobs.size).to eq 1
      end
    end
  end

  context "passwords" do
    let(:user) { create(:user, password: "test_password") }
    let(:valid_forgot_params) { { data: { type: "users", attributes: { email: user.email } } } }
    let(:invalid_forgot_params) { { data: { type: "users", attributes: { email: "a@b.c" } } } }

    let(:valid_reset_params) do
      {
        data: {
          type: "users",
          attributes: { confirmation_token: user.reload.confirmation_token, password: "new" }
        }
      }
    end

    let(:invalid_reset_params) do
      {
        data: {
          type: "users",
          attributes: { confirmation_token: "invalid", password: "new" }
        }
      }
    end

    context "POST /users/forgot_password" do
      it "returns the user when the email is found" do
        post "#{host}/users/forgot_password", valid_forgot_params

        expect(last_response.status).to eq 200
        expect(json).to serialize_object(user).with(UserSerializer)
      end

      it "returns an error when the email is not found" do
        post "#{host}/users/forgot_password", invalid_forgot_params

        expect(last_response.status).to eq 422
        expect(json).
          to be_a_valid_json_api_validation_error.
          with_message "email doesn't exist in the database"
      end
    end

    context "POST /users/reset_password" do
      it "resets the password when the authentication token is valid" do
        post "#{host}/users/forgot_password", valid_forgot_params
        post "#{host}/users/reset_password", valid_reset_params

        expect(last_response.status).to eq 200

        token = authenticate(email: user.email, password: "new")
        expect(token).to_not be_nil
      end

      it "doesn't reset the password when the authentication token is not valid" do
        post "#{host}/users/forgot_password", valid_forgot_params
        post "#{host}/users/reset_password", invalid_reset_params

        expect(last_response.status).to eq 422
        expect(json).
          to be_a_valid_json_api_validation_error.
          with_message "password could not be reset"
      end
    end
  end

  context "PATCH /users/me" do
    let(:user) { create(:user, password: "password") }
    let(:file) { File.open("#{Rails.root}/spec/fixtures/default-avatar.png", "r") }
    let(:base64_image) { Base64.encode64(open(file, &:read)) }

    let(:params) do
      {
        data: {
          id: user.id,
          type: "users",
          attributes: {
            first_name: "Changed",
            last_name: "Changed",
            base_64_photo_data: base64_image
          }
        }
      }
    end

    context "when unauthenticated" do
      it "returns a 401 with a proper error message" do
        patch "#{host}/users/me", params

        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id("NOT_AUTHORIZED")
      end
    end

    context "when authenticated" do
      let(:token) { authenticate(email: user.email, password: "password") }

      it "performs the edit" do
        authenticated_patch "/users/me", params, token

        expect(last_response.status).to eq 200
        expect(json).to serialize_object(user.reload).with(UserSerializer)

        # Check the attributes
        expect(json.data.attributes["first-name"]).to eq "Changed"
        expect(json.data.attributes["last-name"]).to eq "Changed"

        # Updating the base64 image data will kick off an async job
        expect(UpdateProfilePictureWorker.jobs.size).to eq 1
      end
    end
  end
end
