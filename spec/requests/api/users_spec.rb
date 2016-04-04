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

  context 'POST /users' do
    let(:valid_params) do
      {
        data: {
          type: "users",
          attributes: {
            email: "new@example.com",
            password: "password"
          }
        }
      }
    end

    let(:invalid_params) do
      {
        data: {
          type: "users",
          attributes: { }
        }
      }
    end

    it "creates a valid user when a params are valid" do
      post "#{host}/users", valid_params
      expect(last_response.status).to eq 200
      expect(json).to serialize_object(User.last).with(UserSerializer)
    end

    it "fails with a validation error when params are invalid" do
      post "#{host}/users", invalid_params
      expect(last_response.status).to eq 422
      expect(json).to be_a_valid_json_api_validation_error.with_messages([
        "email can't be blank",
        "password can't be blank"
      ])
    end
  end
end
