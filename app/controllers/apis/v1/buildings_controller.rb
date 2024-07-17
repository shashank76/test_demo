class Apis::V1::BuildingsController < ApplicationController
  # Include the BuildingTransformer concern
  include BuildingListResponse
  #These filters are written as private method below
  before_action :find_client, only: %i(create update)
  before_action :find_building, only: %i(update)

  # GET /buildings.json
  # Renders a JSON response with parsed buildings data
  def index
    @buildings = Building.includes(client: [:client_custom_fields], building_custom_field_values: []).page(params[:page]).per(params[:per_page])
    render json: transformed_response_parameters, status: :ok
  end

  # POST /buildings.json
  # Create building data
  def create
    @building = @client.buildings.new(building_params)
    if @building.save
      render json: transformed_single_building_parameters, status: :created
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  # PATCH /buildings.json
  # Update building data
  def update
    if @building.update_building_custom_field_values(building_params)
      render json: transformed_single_building_parameters, status: :ok
    else
      render json: @building.errors, status: :unprocessable_entity
    end
  end

  private
  # This private method to find client with payload client_id for create and update building data
  def find_client
    @client = Client.find_by(id: building_params[:client_id])
    unless @client
      render json: {status: 404, message: :not_found}
    end
  end

  # This private method to find building with payload id for update building data
  def find_building
    @building = @client.buildings.find_by(id: params[:id])
    unless @building
      render json: {status: 404, message: :not_found}
    end
  end

  #permiting parameters for create and update payload
  def building_params
    params.require(:building).permit(
      :address, :state, :zip, :client_id, building_custom_field_values_attributes:
      [:id, :value, :client_custom_field_id, :_destroy]
    )
  end
end
