# == Schema Information
#
# Table name: united_states_subdivisions
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  postal_abbreviation :string           not null
#  fips_code           :string           not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class UnitedStatesSubdivision < ActiveRecord::Base
  has_many :congressional_districts

  validates :fips_code, presence: true
  validates :postal_abbreviation, presence: true, length: { is: 2 }
  validates :name, presence: true
end
