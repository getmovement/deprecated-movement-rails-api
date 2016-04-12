FactoryGirl.define do
  factory :united_states_subdivision do
    name { Faker::Address.state }
    postal_abbreviation { Faker::Address.state_abbr }
    fips_code { Faker::Number.number(2).to_s }
  end
end
