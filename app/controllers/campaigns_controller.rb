class CampaignsController < APIController
  def show
    campaign = Campaign.find(params[:id])
    authorize campaign
    render json: campaign
  end
end
