require "rails_helper"

describe "Addresses API" do
  describe "GET /addresses" do
    context "when unauthenticated" do
      it "responds with a 401" do
        get "#{host}/addresses"

        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id "NOT_AUTHORIZED"
      end
    end

    context "when authenticated" do
      pending "this endpoint should eventually require a campaign_id"

      let(:user) { create(:user, password: "password") }
      let(:token) { authenticate(email: user.email, password: "password") }

      before do
        create_list(:address, 4)
      end

      it "returns a list of addresses" do
        authenticated_get "/addresses", {}, token

        expect(last_response.status).to eq 200
        expect(json).to serialize_collection(Address.all).with(AddressSerializer)
        expect(json.data.length).to eq 4
      end
    end
  end
end
