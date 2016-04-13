require "rails_helper"

describe CampaignVolunteerSerializer, type: :serializer do
  context "individual resource representation" do
    let(:resource) { create(:campaign_volunteer) }
    let(:serializer) { described_class.new(resource) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    context "root" do
      subject do
        JSON.parse(serialization.to_json)["data"]
      end

      it "has an attributes object" do
        expect(subject["attributes"]).to be_nil
      end

      it "has a relationships object" do
        expect(subject["relationships"]).not_to be_nil
      end

      it "has an id" do
        expect(subject["id"]).to eq resource.id.to_s
      end

      it "has a type set to 'campaign_volunteers'" do
        expect(subject["type"]).to eq "campaign_volunteers"
      end
    end

    context "relationships" do
      subject do
        JSON.parse(serialization.to_json)["data"]["relationships"]
      end

      it "has a 'volunteer'" do
        expect(subject["volunteer"]["data"]["id"]).to eq resource.volunteer.id.to_s
        expect(subject["volunteer"]["data"]["type"]).to eq "users"
      end

      it "has a 'campaign'" do
        expect(subject["campaign"]["data"]["id"]).to eq resource.campaign.id.to_s
        expect(subject["campaign"]["data"]["type"]).to eq "campaigns"
      end
    end
  end
end
