class CampaignVolunteerPolicy < ApplicationPolicy
  alias campaign_volunteer record

  def index?
    true
  end

  def create?
    true
  end
end
