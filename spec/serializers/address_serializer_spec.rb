require "rails_helper"

describe UserSerializer, type: :serializer do

  context "individual resource representation" do
    let(:resource) { create(:address) }
    let(:serializer) { AddressSerializer.new(resource) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    context "root" do
      subject do
        JSON.parse(serialization.to_json)["data"]
      end

      it "has an attributes object" do
        expect(subject["attributes"]).not_to be_nil
      end

      it "has no relationships object" do
        expect(subject["relationships"]).to be_nil
      end

      it "has an id" do
        expect(subject["id"]).to eq resource.id.to_s
      end

      it "has a type set to 'addresses'" do
        expect(subject["type"]).to eq "addresses"
      end
    end

    context "attributes" do
      subject do
        JSON.parse(serialization.to_json)["data"]["attributes"]
      end

      it "has an 'street_1'" do
        expect(subject["street_1"]).to eq resource.street_1
      end

      it "has a 'street_2'" do
        expect(subject["street_2"]).to eq resource.street_2
      end

      it "has a 'city'" do
        expect(subject["city"]).to eq resource.city
      end

      it "has a 'state_abbreviation'" do
        expect(subject["state_abbreviation"]).to eq resource.state_abbreviation
      end

      it "has a 'zip_code'" do
        expect(subject["zip_code"]).to eq resource.zip_code
      end

      it "has a 'latitude'" do
        expect(subject["latitude"]).to eq resource.latitude
      end

      it "has a 'longitude'" do
        expect(subject["longitude"]).to eq resource.longitude
      end
    end

    context "relationships" do
      subject do
        JSON.parse(serialization.to_json)["data"]["relationships"]
      end

      it "has none" do
        expect(subject).to be_nil
      end
    end

    context "included" do
      context "when not including anything" do
        subject do
          JSON.parse(serialization.to_json)["included"]
        end

        it "is empty" do
          expect(subject).to be_nil
        end
      end
    end
  end
end
