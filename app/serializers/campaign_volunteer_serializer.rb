class CampaignVolunteerSerializer < ActiveModel::Serializer
  attributes :id

  belongs_to :volunteer
  belongs_to :campaign
end
