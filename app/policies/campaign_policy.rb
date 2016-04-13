class CampaignPolicy < ApplicationPolicy
  alias campaign record

  def index?
    true
  end

  def show?
    true
  end
end
