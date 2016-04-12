require 'rails_helper'

RSpec.describe CongressionalDistrict, type: :model do
  describe "schema" do
    it { should have_db_column(:united_states_subdivision_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:number).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:state_postal_abbreviation).of_type(:string).with_options(null: false) }
    it { should have_db_column(:state_name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:congress_session).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:created_at) }
    it { should have_db_column(:updated_at) }

    it { should have_db_index(:polygon) }
  end

  describe "relationships" do
    it { should belong_to(:united_states_subdivision) }
  end

  describe "validations" do
    it { should validate_presence_of(:united_states_subdivision) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:state_postal_abbreviation) }
    it { should validate_presence_of(:state_name) }
    it { should validate_presence_of(:congress_session) }

    it { should validate_length_of(:state_postal_abbreviation).is_equal_to(2) }
  end

  it "has a valid factory" do
    expect(create(:congressional_district)).to be_valid
  end
end
