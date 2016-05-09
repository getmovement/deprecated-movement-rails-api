require "rails_helper"

describe CampaignSerializer, type: :serializer do
  context "individual resource representation" do
    let(:resource) { create(:campaign) }
    let(:serializer) { described_class.new(resource) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    context "root" do
      subject do
        JSON.parse(serialization.to_json)["data"]
      end

      it "has an attributes object" do
        expect(subject["attributes"]).not_to be_nil
      end

      it "has a relationships object" do
        expect(subject["relationships"]).not_to be_nil
      end

      it "has an id" do
        expect(subject["id"]).to eq resource.id.to_s
      end

      it "has a type set to 'campaigns'" do
        expect(subject["type"]).to eq "campaigns"
      end
    end

    context "attributes" do
      subject do
        JSON.parse(serialization.to_json)["data"]["attributes"]
      end

      it "has an 'title'" do
        expect(subject["title"]).not_to be_nil
        expect(subject["title"]).to eq resource.title
      end

      it "has a 'description'" do
        expect(subject["description"]).not_to be_nil
        expect(subject["description"]).to eq resource.description
      end
    end

    context "relationships" do
      before do
        create_list(:campaign_volunteer, 5, campaign: resource)
      end

      subject do
        JSON.parse(serialization.to_json)["data"]["relationships"]
      end

      it "has 'volunteers'" do
        expect(subject["volunteers"]["data"].length).to eq 5
      end

      it "has 'campaign_volunteers'" do
        expect(subject["campaign_volunteers"]["data"].length).to eq 5
      end
    end
  end
end
