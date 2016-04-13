class CampaignVolunteersController < APIController
  before_action :doorkeeper_authorize!, only: [:index, :create]

  def index
    authorize CampaignVolunteer
    render json: CampaignVolunteer.where(index_params)
  end

  def create
    campaign_volunteer = CampaignVolunteer.new(create_params)
    authorize campaign_volunteer

    if campaign_volunteer.save
      render json: campaign_volunteer, serializer: CampaignVolunteerSerializer
    else
      render_validation_errors(campaign_volunteer)
    end
  end

  private

    def index_params
      {
        campaign_id: params.require(:campaign_id)
      }
    end

    def campaign_id
      record_relationships.fetch(:campaign, {}).fetch(:data, {}).fetch(:id, nil)
    end

    def create_params
      {
        campaign_id: campaign_id,
        volunteer_id: current_user.id
      }
    end
end
