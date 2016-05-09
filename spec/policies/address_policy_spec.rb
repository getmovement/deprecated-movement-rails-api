require "rails_helper"

RSpec.describe AddressPolicy do
  subject { described_class }

  permissions :index? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, User)
    end
  end
end
