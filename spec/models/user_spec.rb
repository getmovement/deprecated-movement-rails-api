require 'rails_helper'

RSpec.describe User, type: :model do
  describe "schema" do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string) }

    it { should have_db_column(:updated_at) }
    it { should have_db_column(:created_at) }

    it { should have_db_index(:email).unique }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  it "has a valid factory" do
    expect(create(:user)).to be_valid
  end
end
