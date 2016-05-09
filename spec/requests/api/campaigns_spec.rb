require "rails_helper"

describe "Campaigns API" do
  describe "GET /campaigns/:id" do
    let(:campaign) { FactoryGirl.create(:campaign) }

    it "returns the specified campaign" do
      get "#{host}/campaigns/#{campaign.id}"
      expect(last_response.status).to eq 200
      expect(json).to serialize_object(campaign).with(CampaignSerializer)
    end
  end
end
