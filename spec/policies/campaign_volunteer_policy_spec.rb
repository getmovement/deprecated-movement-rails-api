require "rails_helper"

RSpec.describe CampaignVolunteerPolicy do
  subject { described_class }

  permissions :index? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, CampaignVolunteer)
    end
  end

  permissions :create? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, CampaignVolunteer)
    end
  end
end
