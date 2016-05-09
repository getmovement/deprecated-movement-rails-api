require "rails_helper"

describe UserPolicy do
  subject { described_class }

  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }

  permissions :show? do
    it "is permited for anyone" do
      expect(subject).to permit(nil, User)
    end
  end

  permissions :create? do
    it "is permitted for anyone" do
      expect(subject).to permit(nil, User)
    end
  end

  permissions :update_authenticated_user? do
    it "is permitted for users updating themselves" do
      expect(subject).to permit(user_1, user_1)
      expect(subject).to permit(user_2, user_2)
    end

    it "is not permitted for users updating someone else" do
      expect(subject).not_to permit(user_2, user_1)
      expect(subject).not_to permit(user_1, user_2)
    end
  end

  permissions :forgot_password? do
    it "is permitted for anyone" do
      expect(subject).to permit(nil, User)
    end
  end

  permissions :reset_password? do
    it "is permitted for anyone" do
      expect(subject).to permit(nil, User)
    end
  end
end
