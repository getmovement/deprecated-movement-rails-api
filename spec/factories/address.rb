FactoryGirl.define do
  factory :address do
    street_1 { Faker::Address.street_address }
    street_2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state_abbreviation { Faker::Address.state_abbr }
    zip_code { Faker::Address.zip_code }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }
  end
end
