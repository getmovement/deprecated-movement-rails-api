require "rails_helper"
require "webmock/rspec"

describe UpdateProfilePictureWorker do
  context "when the user has 'base_64_photo_data'" do
    let(:base_64_image) { Base64.encode64(open(file, &:read)) }
    let(:file) { File.open("#{Rails.root}/spec/fixtures/default-avatar.png", "r") }
    let(:user) { create(:user, base_64_photo_data: base_64_image) }

    it "sets 'photo', then unsets 'base_64_photo_data'" do
      UpdateProfilePictureWorker.new.perform(user.id)

      user.reload
      expect(user.photo.to_s).not_to include "user_default"
      expect(user.photo.to_s).not_to be_nil
      expect(user.base_64_photo_data).to be_nil
    end

    it "decodes the image using the Base64ImageDecoder" do
      expect(Base64ImageDecoder).to receive(:decode)

      UpdateProfilePictureWorker.new.perform(user.id)
    end
  end

  context "when the user is a facebook user" do
    let(:user) { create(:user, facebook_id: "test_id", facebook_access_token: "test_token") }
    let(:photo) { File.read("#{Rails.root}/spec/fixtures/default-avatar.png") }
    let(:photo_url) { "https://example.com/photo.png" }
    let(:facebook_service) { double("FacebookService", profile_photo: photo_url) }

    before do
      allow(FacebookService).to receive(:from_user).and_return(facebook_service)
    end

    it "adds a profile picture from facebook" do
      expect_any_instance_of(User).to receive(:photo=).with(URI.parse(photo_url))
      UpdateProfilePictureWorker.new.perform(user.id)
    end
  end

  context "when the user does not have 'base64_photo_data' or facebook data" do
    let(:user) { create(:user) }

    it "doesn't touch photo" do
      UpdateProfilePictureWorker.new.perform(user.id)

      user.reload
      expect(user.photo.to_s).to include "user_default"
    end
  end
end
