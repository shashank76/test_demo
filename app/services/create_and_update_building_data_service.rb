class CreateAndUpdateBuildingDataService
  attr_reader :building, :errors

  # Initializes the service with building params, custom fields params, and the building object
  def initialize(building_params, custom_fields_params, building)
    @building_params = building_params
    @custom_fields_params = custom_fields_params
    @building = building
    @errors = []
  end

  # This method is using to created or updated the building data with exception handelling and logger
  def create_or_update
    if @building.persisted?
      update_building
    else
      create_building
    end
  rescue StandardError => e
    Rails.logger.error("Error in CreateAndUpdateBuildingDataService: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @errors << e.message
  end

  private
  # Creates a new building and its custom fields within a transaction
  def create_building
    ActiveRecord::Base.transaction do
      @building.save!
      create_or_update_custom_fields
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error in CreateAndUpdateBuildingDataService: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @errors << e.message
    raise ActiveRecord::Rollback
  end

  # Updates an existing building and its custom fields within a transaction
  def update_building
    ActiveRecord::Base.transaction do
      @building.update!(@building_params)
      create_or_update_custom_fields
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error in CreateAndUpdateBuildingDataService: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @errors << e.message
    raise ActiveRecord::Rollback
  end

  # Creates or updates custom fields associated with the building
  def create_or_update_custom_fields
    return unless @custom_fields_params

    @custom_fields_params.each do |custom_field|
      if custom_field[:client_custom_field_id].present?
        existing_field = @building.building_custom_field_values.find_by(client_custom_field_id: custom_field[:client_custom_field_id])
        if existing_field.present?
          existing_field.update!(value: custom_field[:value])
        else
          @building.building_custom_field_values.create!(client_custom_field_id: custom_field[:client_custom_field_id], value: custom_field[:value])
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Error in CreateAndUpdateBuildingDataService: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
    @errors << e.message
    raise ActiveRecord::Rollback
  end
end