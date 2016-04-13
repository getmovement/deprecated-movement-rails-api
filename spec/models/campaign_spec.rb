require "rails_helper"

RSpec.describe Campaign, type: :model do
  describe "schema" do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:text).with_options(null: false) }
  end

  describe "relationships" do
    it { should have_many(:campaign_volunteers) }
    it { should have_many(:volunteers).through(:campaign_volunteers) }
  end

  describe "validations" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
