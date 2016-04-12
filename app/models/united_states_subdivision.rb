class UnitedStatesSubdivision < ActiveRecord::Base
  has_many :congressional_districts

  validates :fips_code, presence: true
  validates :postal_abbreviation, presence: true, length: { is: 2 }
  validates :name, presence: true
end
