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

FactoryGirl.define do
  factory :united_states_subdivision do
    name { Faker::Address.state }
    postal_abbreviation { Faker::Address.state_abbr }
    fips_code { Faker::Number.number(2).to_s }
  end
end
