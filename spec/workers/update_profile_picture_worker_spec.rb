require 'rails_helper'

describe UpdateProfilePictureWorker do
  context "when the user has 'base_64_photo_data'" do
    let(:base_64_image) { Base64.encode64(open(file, &:read)) }
    let(:file) { File.open("#{Rails.root}/spec/sample_data/default-avatar.png", 'r') }
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

  context "when the user does not have 'base64_photo_data'" do
    let(:user) { create(:user) }

    it "doesn't touch photo" do
      UpdateProfilePictureWorker.new.perform(user.id)

      user.reload
      expect(user.photo.to_s).to include "user_default"
    end
  end
end
