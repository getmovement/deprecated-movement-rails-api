FactoryGirl.define do
  factory :campaign do
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph }
  end
end
