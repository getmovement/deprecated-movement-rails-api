class CampaignVolunteer < ActiveRecord::Base
  belongs_to :volunteer, class_name: "User"
  belongs_to :campaign

  validates :volunteer, presence: true, uniqueness: { scope: :campaign }
  validates :campaign, presence: true
end
