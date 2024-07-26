class Apis::V1::BuildingsController < ApplicationController
  # Include the Building data transformation concern
  include BuildingListResponse

  #These filters are written as private method below
  before_action :find_client, only: %i(create update)
  before_action :find_building, only: %i(update)

  # GET /buildings.json
  # Renders a JSON response with parsed buildings data
  def index
    @buildings = building_list.page(params[:page]).per(params[:per_page])
    render json: transformed_response_parameters, status: :ok
  end

  # POST /buildings.json
  # Create building data
  def create
    building_data_service.create_or_update
    if building_data_service.building.persisted?
      @building = building_data_service.building
      render json: transformed_building_parameters, status: :created
    else
      render json: building_data_service.errors, status: :unprocessable_entity
    end
  end

  # PATCH /buildings.json
  # Update building data
  def update
    building_data_service.create_or_update
    if building_data_service.errors.empty?
      @building = building_data_service.building
      render json: transformed_building_parameters, status: :ok
    else
      render json: building_data_service.errors, status: :unprocessable_entity
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

  # Calling Building Data Service to Create and update custom field data
  def building_data_service
    @building_data_service ||= CreateAndUpdateBuildingDataService.new(
      building_params, custom_fields_params, building_data
    )
  end

  def building_data
    @building ||= @client.buildings.new(building_params)
  end

  # Memoizes the result of the query to avoid fetching data multiple times
  def building_list
    @building_list ||= Building.includes(:building_custom_field_values,
      client: [:client_custom_fields]
    ).order('created_at desc')
  end

  #permiting parameters for create and update payload
  def building_params
    params.require(:building).permit(:address, :state, :zip, :client_id)
  end

  #custom field values parameters
  def custom_fields_params
    params[:building_custom_field_values_attributes]
  end
end
