require "rails_helper"
require "movement_api/base64_image_decoder"

module MovementApi
  describe Base64ImageDecoder do
    describe "#decode" do
      let(:decoder) { Base64ImageDecoder }
      let(:user) { create(:user) }
      let(:result) { decoder.decode(base64_string) }
      let(:base64_string) { File.open(filename, &:read) }

      context "when base64 string has data string" do
        let(:filename) { "#{Rails.root}/spec/sample_data/base64_images/jpeg.txt" }

        it "sets the right content type and filename" do
          expect(result.content_type).to eq "image/png"
          expect(result.original_filename).to include ".png"
        end

        it "returns valid image data for Paperclip" do
          user.photo = result
          expect(user).to be_valid
        end
      end

      context "when base64 string has no data string" do
        let(:filename) { "#{Rails.root}/spec/sample_data/base64_images/jpeg_without_data_string.txt" }

        it "sets the right content type and filename" do
          expect(result.content_type).to eq "image/png"
          expect(result.original_filename).to include ".png"
        end

        it "returns valid image data for Paperclip" do
          user.photo = result
          expect(user).to be_valid
        end
      end
    end
  end
end
