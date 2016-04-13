class CampaignSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :volunteers
  has_many :campaign_volunteers
end
