require "rails_helper"

describe UserSerializer, type: :serializer do

  context "individual resource representation" do
    let(:resource) { create(:user) }
    let(:serializer) { UserSerializer.new(resource) }
    let(:serialization) { ActiveModelSerializers::Adapter.create(serializer) }

    context "root" do
      subject do
        JSON.parse(serialization.to_json)['data']
      end

      it "has an attributes object" do
        expect(subject["attributes"]).not_to be_nil
      end

      it "has a relationships object" do
        expect(subject["relationships"]).to be_nil
      end

      it "has an id" do
        expect(subject["id"]).to eq resource.id.to_s
      end

      it "has a type set to `users`" do
        expect(subject["type"]).to eq "users"
      end
    end

    context "attributes" do
      subject do
        JSON.parse(serialization.to_json)['data']['attributes']
      end

      it "has an 'email'" do
        expect(subject["email"]).to eq resource.email
      end

      it "has a 'photo_thumb_url'" do
        expect(subject["photo_thumb_url"]).to eq resource.photo.url(:thumb)
      end

      it "has a 'photo_large_url'" do
        expect(subject["photo_large_url"]).to eq resource.photo.url(:large)
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

        it "should be empty" do
          expect(subject).to be_nil
        end
      end
    end
  end
end
