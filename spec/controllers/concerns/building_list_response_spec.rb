require 'rails_helper'

# Dummy controller to include the concern for testing
class DummyController < ApplicationController
  include BuildingListResponse

  def initialize(buildings, building = nil)
    @buildings = buildings
    @building = building
  end

  def params
    ActionController::Parameters.new({})
  end
end

RSpec.describe BuildingListResponse do
  let(:client) { create(:client, name: 'Test Client') }
  let(:client_custom_field1) { create(:client_custom_field) }
  let(:client_custom_field2) { create(:client_custom_field, field_name: "Test Field", field_type: 'freeform') }
  let(:buildings) { create_list(:building, 3, client: client) }
  let(:building_custom_field_value1) {
    create(:building_custom_field_value, building_id: buildings.first.id, client_custom_field_id: client_custom_field1.id)
  }
  let(:building_custom_field_value2) {
    create(:building_custom_field_value, building_id: buildings.first.id, client_custom_field_id: client_custom_field2.id)
  }
  

  subject(:dummy_controller) { DummyController.new(buildings) }

  describe '#transformed_response_parameters' do
    it 'transforms a list of buildings' do
      transformed_parameters = dummy_controller.send(:transformed_response_parameters)
      expect(transformed_parameters.size).to eq(3)
      expect(transformed_parameters.first.keys).to match_array([:id, :address, :client_name])
    end
  end

  describe '#transformed_single_building_parameters' do
    let(:building) { buildings.first }

    before do
      dummy_controller.instance_variable_set(:@building, building)
    end

    it 'transforms a single building' do
      transformed_parameters = dummy_controller.send(:transformed_single_building_parameters)
      expect(transformed_parameters.keys).to match_array([:id, :address, :client_name])
    end
  end

  describe '#full_address' do
    let(:building) { buildings.first }

    it 'returns the full address' do
      full_address = dummy_controller.send(:full_address, building)
      expect(full_address).to eq("#{building.address} #{building.state} #{building.zip}")
    end
  end

  describe '#custom_field_values' do
    let(:building) { buildings.first }
    let!(:custom_field_1) { create(:client_custom_field, client: client, field_name: 'Custom Field 1') }
    let!(:custom_field_2) { create(:client_custom_field, client: client, field_name: 'Custom Field 2') }
    let!(:building_custom_field_value_1) { create(:building_custom_field_value, building: building, client_custom_field: custom_field_1, value: 'Value 1') }

    it 'formats custom field values' do
      custom_values = dummy_controller.send(:custom_field_values, building)
      expect(custom_values.keys).to match_array(['Custom Field 1', 'Custom Field 2'])
      expect(custom_values['Custom Field 1']).to eq('Value 1')
      expect(custom_values['Custom Field 2']).to eq('')
    end
  end
end
