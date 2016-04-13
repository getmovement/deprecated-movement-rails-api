FactoryGirl.define do
  factory :campaign_volunteer do
    association :volunteer, factory: :user
    association :campaign
  end
end
