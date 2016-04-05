require "rails_helper"

describe "Tokens API" do
  describe "POST /oauth/tokens" do
    context "with an email and password" do
      let(:user) { create(:user, id: 10, password: "test_password") }

      it "returns a token when both email and password are valid" do
        post "#{host}/oauth/token",
             grant_type: "password",
             username: user.email,
             password: "test_password"

        expect(last_response.status).to eq 200
        expect(json.access_token).not_to be nil
      end

      it "fails with 401 when email is invalid" do
        post "#{host}/oauth/token",
             grant_type: "password",
             username: "invalid-email@mail.com",
             password: "test_password"

        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id "INVALID_GRANT"
      end

      it "fails with 401 when password is invalid" do
        post "#{host}/oauth/token",
             grant_type: "password",
             username: "existing-user@mail.com",
             password: "invalid_password"

        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id "INVALID_GRANT"
      end
    end

    context "with a facebook_auth_code" do
      context "when facebook user is missing", vcr: { cassette_name: "facebook_user_not_found" } do
        it "fails with 400" do
          post "#{host}/oauth/token",
               grant_type: "password",
               username: "facebook",
               password: "non-existant-token"

          expect(last_response.status).to eq 400
          expect(json).to be_a_valid_json_api_error.with_id "FACEBOOK_AUTHENTICATION_ERROR"
        end
      end

      context "when facebook user exists", vcr: { cassette_name: "facebook_user_found" } do
        include FacebookHelpers
        let(:facebook_user) { create_facebook_test_user }
        let(:facebook_id) { facebook_user["id"] }
        let(:access_token) { create_facebook_access_token(facebook_user) }

        let(:params) { { grant_type: "password", username: "facebook", password: access_token } }

        context "and there's a user with facebook_id in the database" do
          before do
            create(:user, facebook_id: facebook_id)
          end

          it "returns a token" do
            post "#{host}/oauth/token", params

            expect(last_response.status).to eq 200
            expect(json.access_token).not_to be nil
          end
        end

        context "and theres no user with that facebook_id in the database" do
          it "fails with a 404" do
            post "#{host}/oauth/token", params

            expect(last_response.status).to eq 404
            expect(json).to be_a_valid_json_api_error.with_id "RECORD_NOT_FOUND"
          end
        end
      end
    end
  end
end
