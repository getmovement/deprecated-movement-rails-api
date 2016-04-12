require "rails_helper"
# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  encrypted_password :string(128)
#  confirmation_token :string(128)
#  remember_token     :string(128)
#  base_64_photo_data :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  first_name         :string
#  last_name          :string
#

RSpec.describe User, type: :model do
  describe "schema" do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string) }

    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }

    it { should have_db_column(:base_64_photo_data).of_type(:string) }

    it { should have_db_column(:facebook_id).of_type(:string) }
    it { should have_db_column(:facebook_access_token).of_type(:string) }

    it { should have_db_column(:updated_at) }
    it { should have_db_column(:created_at) }

    it { should have_db_index(:email).unique }
  end

  describe "relationships" do
    it { should have_attached_file(:photo) }

    # rubocop:disable LineLength
    it { should have_many(:active_relationships).class_name("UserRelationship").dependent(:destroy) }
    it { should have_many(:passive_relationships).class_name("UserRelationship").dependent(:destroy) }
    # rubocop:enable LineLength

    it { should have_many(:following).through(:active_relationships).source(:following) }
    it { should have_many(:followers).through(:passive_relationships).source(:follower) }

    # rubocop:disable LineLength
    it { should have_many(:campaign_volunteerships).class_name("CampaignVolunteer").with_foreign_key(:volunteer_id) }
    # rubocop:enable LineLength

    it { should have_many(:campaigns).through(:campaign_volunteerships) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }

    it { should_not validate_attachment_presence(:photo) }
    it { should validate_attachment_size(:photo).less_than(10.megabytes) }
  end

  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end

  describe "social relationships behavior" do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }

    describe "#follow" do
      it "follows the specified user by creating a UserRelationship record" do
        expect { first_user.follow(second_user) }.to change { UserRelationship.count }.by(1)
        new_relationship = UserRelationship.last
        expect(new_relationship.follower).to eq first_user
        expect(new_relationship.following).to eq second_user
      end
    end

    describe "#unfollow" do
      before do
        create(:user_relationship, follower: first_user, following: second_user)
      end

      it "unfollows the specified user by destroying the associated UserRelationship record" do
        expect { first_user.unfollow(second_user) }.to change { UserRelationship.count }.by(-1)
      end
    end

    describe "#following?" do
      it "returns true if the user is following the specified user" do
        create(:user_relationship, follower: first_user, following: second_user)
        expect(first_user.reload.following?(second_user)).to be true
      end

      it "returns false if the user is not following the specified user" do
        expect(first_user.reload.following?(second_user)).to be false
      end
    end
  end
end
