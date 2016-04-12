require "rails_helper"

# NOTE: Some of the requests being recorded by VCR here are quite long
# so re-recording them might take a long time, in order of minutes per
# request for some requests

describe FacebookService do
  include FacebookHelpers

  let(:test_users) { create_facebook_test_users }
  let(:facebook_user) { test_users.create(true, "email,user_friends") }
  let(:access_token) { create_facebook_access_token(facebook_user) }

  subject do
    described_class.new(token: access_token)
  end

  describe "#profile_photo", vcr: { cassette_name: "facebook/profile_photo" } do
    it "should return a profile_photo url" do
      photo_url = subject.profile_photo
      expect(photo_url).to be_present
      expect(photo_url).to include ".jpg"
    end
  end

  describe "#facebook_id", vcr: { cassette_name: "facebook/facebook_id" } do
    it "should return the facebook user's id" do
      expect(subject.facebook_id).to eq facebook_user["id"]
    end
  end

  describe "#facebook_friend_ids" do
    let(:container) { Array.new(friend_count) }
    let(:friend_users) { container.map { test_users.create(true, "email,user_friends") } }
    let(:friend_ids) { friend_users.map { |friend| friend["id"] } }

    before do
      friend_users.each { |friend| test_users.befriend(facebook_user, friend) }
    end

    context "when the facebook user has no friends", vcr: {
      cassette_name: "facebook/friend_ids_no_friends"
    } do
      let(:friend_count) { 0 }
      it "returns an empty array" do
        expect(subject.facebook_friend_ids).to eq []
      end
    end

    context "when the facebook user has a single page of friends", vcr: {
      cassette_name: "facebook/friend_ids_one_page"
    } do
      let(:friend_count) { 5 }
      it "returns an array containing all the ids" do
        expect(subject.facebook_friend_ids).to contain_exactly(*friend_ids)
      end
    end

    context "when the facebook user has multiple pages of friends", vcr: {
      cassette_name: "facebook/friend_ids_multiple_pages"
    } do
      let(:friend_count) { 15 }
      it "returns an array containing all the ids" do
        expect(subject.facebook_friend_ids).to contain_exactly(*friend_ids)
      end
    end
  end
end
