class Campaign < ActiveRecord::Base
  has_many :campaign_volunteers
  has_many :volunteers, through: :campaign_volunteers

  validates :title, presence: true
  validates :description, presence: true
end
