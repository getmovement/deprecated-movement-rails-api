require "rails_helper"

describe UserRelationship, type: :model do
  describe "schema" do
    it { should have_db_column(:follower_id) }
    it { should have_db_column(:following_id) }

    it { should have_db_index(:follower_id) }
    it { should have_db_index(:following_id) }

    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }

    it { should have_db_index(:follower_id) }
    it { should have_db_index(:following_id) }
    it { should have_db_index([:follower_id, :following_id]).unique }
  end

  describe "relationships" do
    it { should belong_to(:follower).class_name("User") }
    it { should belong_to(:following).class_name("User") }
  end

  describe "validations" do
    it { should validate_presence_of(:follower) }
    it { should validate_presence_of(:following) }

    # this one does not work when :follower_id and :following_id columns are
    # set as not nullable
    # it { should validate_uniqueness_of(:follower_id).scoped_to(:following_id) }

    it "validates uniqueness of follower scoped to following" do
      follower_1 = create(:user)
      follower_2 = create(:user)
      following = create(:user)
      create(:user_relationship, follower: follower_1, following: following)

      expect(build(:user_relationship, follower: follower_1, following: following)).not_to be_valid
      expect(build(:user_relationship, follower: follower_2, following: following)).to be_valid
    end
  end
end
