require "rails_helper"

RSpec.describe Address, type: :model do
  describe "schema" do
    it { should have_db_column(:latitude).of_type(:float).with_options(null: false) }
    it { should have_db_column(:longitude).of_type(:float).with_options(null: false) }
    it { should have_db_column(:street_1).of_type(:string).with_options(null: false) }
    it { should have_db_column(:street_2).of_type(:string) }
    it { should have_db_column(:city).of_type(:string) }
    it { should have_db_column(:state_abbreviation).of_type(:string).with_options(null: false) }
    it { should have_db_column(:zip_code).of_type(:string) }

    it { should have_db_column(:updated_at) }
    it { should have_db_column(:created_at) }
  end

  context "validations" do
    it { should validate_presence_of(:street_1) }
    it { should validate_presence_of(:state_abbreviation) }

    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }

    it do
      should validate_numericality_of(:latitude).
        is_greater_than_or_equal_to(-90).
        is_less_than_or_equal_to(90)
    end

    it do
      should validate_numericality_of(:longitude).
        is_greater_than_or_equal_to(-180).
        is_less_than_or_equal_to(180)
    end

    it "requires at least city or zip code", :aggregate_failures do
      expect(build(:address, zip_code: nil, city: "Something")).to be_valid
      expect(build(:address, zip_code: "ABC", city: nil)).to be_valid
      expect(build(:address, zip_code: "ABC", city: "Something")).to be_valid
      expect(build(:address, zip_code: nil, city: nil)).not_to be_valid
    end
  end
end
