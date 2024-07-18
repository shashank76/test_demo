module BuildingListResponse
  extend ActiveSupport::Concern

  # Make methods available as helper methods in controllers
  included do
    helper_method :transformed_response_parameters, :transformed_single_building_parameters
  end

  # Transforming a list of buildings data into a JSON structure
  def transformed_response_parameters
    @buildings.map { |building| transform_building(building) }
  end

  # Transforming a single building data into a JSON structure
  def transformed_single_building_parameters
    transform_building(@building)
  end

  private

  # Transform a building into a structured response
  def transform_building(building)
    {
      id: building.id,
      address: full_address(building),
      client_name: building.client.name
    }.merge(custom_field_values(building))
  end

  # full address string
  def full_address(building)
    "#{building.address} #{building.state} #{building.zip}"
  end

  # format custom field values
  def custom_field_values(building)
    building_custom_values = building.building_custom_field_values.pluck(
      :client_custom_field_id, :value
    ).to_h
    
    client_custom_fields = building.client.client_custom_fields
    client_custom_fields.each_with_object({}) do |client_custom_field, hash|
      hash[client_custom_field.field_name] = building_custom_values[client_custom_field.id] || ''
    end

  end

end
