require 'rails_helper'

RSpec.describe User, type: :model do
  describe "schema" do
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
    it { should have_db_column(:encrypted_password).of_type(:string) }

    it { should have_db_column(:first_name).of_type(:string) }
    it { should have_db_column(:last_name).of_type(:string) }

    it { should have_db_column(:base_64_photo_data).of_type(:string) }

    it { should have_db_column(:updated_at) }
    it { should have_db_column(:created_at) }

    it { should have_db_index(:email).unique }
  end

  describe "relationships" do
    it { should have_attached_file(:photo) }
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
end
