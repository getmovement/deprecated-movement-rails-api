FactoryGirl.define do
  factory :device do
    association :user

    platform "Android"
    token "12345"
    enabled true
  end
end
