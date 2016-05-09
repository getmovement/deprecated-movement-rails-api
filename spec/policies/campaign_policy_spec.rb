require "rails_helper"

RSpec.describe CampaignPolicy do
  subject { described_class }

  permissions :index? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, Campaign)
    end
  end

  permissions :show? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, Campaign)
    end
  end
end
