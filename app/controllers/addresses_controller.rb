class AddressesController < APIController
  before_action :doorkeeper_authorize!, only: [:index]

  def index
    authorize Address
    render json: Address.all
  end
end
