require "rails_helper"

RSpec.describe CampaignVolunteer, type: :model do
  describe "schema" do
    it { should have_db_index(:campaign_id) }
    it { should have_db_index(:volunteer_id) }
  end

  describe "relationships" do
    it { should belong_to(:volunteer).class_name("User") }
    it { should belong_to(:campaign) }
  end

  describe "validations" do
    it { should validate_presence_of(:volunteer) }
    it { should validate_presence_of(:campaign) }

    it "validates uniqueness of volunteer scoped to campaign" do
      campaign_1 = create(:campaign)
      campaign_2 = create(:campaign)
      user = create(:user)
      create(:campaign_volunteer, volunteer: user, campaign: campaign_1)
      expect(build(:campaign_volunteer, volunteer: user, campaign: campaign_1)).not_to be_valid
      expect(build(:campaign_volunteer, volunteer: user, campaign: campaign_2)).to be_valid
    end
  end
end
