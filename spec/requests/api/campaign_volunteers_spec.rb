require "rails_helper"

describe "CampaignVolunteers API" do
  describe "GET /campaign_volunteers" do
    context "when unauthenticated" do
      it "returns a 401" do
        get "#{host}/campaign_volunteers"
        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id("NOT_AUTHORIZED")
      end
    end

    context "when authenticated" do
      let(:user) { create(:user, password: "test") }
      let(:token) { authenticate(email: user.email, password: "test") }

      context "when no campaign_id parameter is provided" do
        it "responds with a 400" do
          authenticated_get "/campaign_volunteers", {}, token
          expect(last_response.status).to eq 400
          expect(json).to be_a_valid_json_api_error.with_id "PARAMETER_MISSING"
        end
      end

      context "when campaign_id is provided" do
        let(:campaign) { create(:campaign) }

        before do
          create_list(:campaign_volunteer, 3, campaign_id: campaign.id)
          create_list(:campaign_volunteer, 2)
        end

        it "returns all campaign volunteers for the specified campaign" do
          authenticated_get "/campaign_volunteers", { campaign_id: campaign.id }, token

          expect(last_response.status).to eq 200
          expect(json).
            to serialize_collection(CampaignVolunteer.where(campaign_id: campaign.id)).
            with(CampaignVolunteerSerializer)
        end
      end
    end
  end

  describe "POST /campaign_volunteers" do
    context "when unauthenticated" do
      it "returns a 401" do
        post "#{host}/campaign_volunteers"
        expect(last_response.status).to eq 401
        expect(json).to be_a_valid_json_api_error.with_id("NOT_AUTHORIZED")
      end
    end

    context "when authenticated" do
      let(:user) { create(:user, password: "test") }
      let(:token) { authenticate(email: user.email, password: "test") }

      context "when no campaign_id parameter is provided" do
        it "responds with a validation error" do
          authenticated_post "/campaign_volunteers", {}, token
          expect(last_response.status).to eq 422
          expect(json).to be_a_valid_json_api_validation_error
        end
      end

      context "when campaign_id is provided" do
        let(:campaign) { create(:campaign) }
        let(:params) do
          {
            data: {
              type: "campaigns",
              relationships: {
                campaign: { data: { id: campaign.id } }
              }
            }
          }
        end

        it "returns all campaign volunteers for the specified campaign", :aggregate_failures do
          expect { authenticated_post "/campaign_volunteers", params, token }.
            to change { CampaignVolunteer.count }.from(0).to(1)

          created_record = CampaignVolunteer.last
          expect(created_record.volunteer).to eq user
          expect(created_record.campaign).to eq campaign

          expect(last_response.status).to eq 200
          expect(json).to serialize_object(created_record).with(CampaignVolunteerSerializer)
        end
      end
    end
  end
end
