require 'rails_helper'

RSpec.describe UnitedStatesSubdivision, type: :model do
  describe "schema" do
    it { should have_db_column(:fips_code).of_type(:string).with_options(null: false) }
    it { should have_db_column(:postal_abbreviation).of_type(:string).with_options(null: false) }
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }

    it { should have_db_index(:fips_code) }
    it { should have_db_index(:postal_abbreviation) }
  end

  describe "relationships" do
    it { should have_many(:congressional_districts) }
  end

  describe "validations" do
    it { should validate_presence_of(:fips_code) }
    it { should validate_presence_of(:postal_abbreviation) }
    it { should validate_presence_of(:name) }

    it { should validate_length_of(:postal_abbreviation).is_equal_to(2) }
  end

  it "has a valid factory" do
    expect(create(:united_states_subdivision)).to be_valid
  end
end
