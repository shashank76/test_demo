require 'rails_helper'

RSpec.describe CreateAndUpdateBuildingDataService, type: :service do
  let(:client) { FactoryBot.create(:client) }
  let(:building_params) { { address: '123 Test St', state: 'NY', zip: '10001', client_id: client.id } }
  let(:client_custom_field1) { create(:client_custom_field) }
  let(:client_custom_field2) { create(:client_custom_field, field_name: "Test Field", field_type: 'freeform') }
  let(:custom_fields_params) { [
    { client_custom_field_id: client_custom_field1.id, value: 'Value 1' },
    { client_custom_field_id: client_custom_field2.id, value: 'Value 2' }] }
  let(:building) { Building.new(building_params) }
  let(:service) { CreateAndUpdateBuildingDataService.new(building_params, custom_fields_params, building) }

  describe '#create_or_update' do
    context 'when the building is new' do
      it 'creates a new building' do
        expect { service.create_or_update }.to change(Building, :count).by(1)
      end

      it 'creates new custom fields' do
        service.create_or_update
        expect(building.building_custom_field_values.count).to eq(2)
      end
    end

    context 'when the building already exists' do
      let!(:existing_building) { Building.create!(building_params) }
      let(:service) { CreateAndUpdateBuildingDataService.new(building_params.merge(address: 'New Address Test'), custom_fields_params, existing_building) }

      it 'updates the existing building' do
        service.create_or_update
        expect(existing_building.reload.address).to eq('New Address Test')
      end

      it 'creates or updates custom fields' do
        existing_building.building_custom_field_values.create!(client_custom_field_id: client_custom_field1.id, value: 'Old Value')
        service.create_or_update
        expect(
          existing_building.building_custom_field_values.find_by(
            client_custom_field_id: client_custom_field1.id
          ).value).to eq('Value 1')
        expect(existing_building.building_custom_field_values.find_by(
          client_custom_field_id: client_custom_field2.id
        ).value).to eq('Value 2')
      end
    end

    context 'when an error occurs' do
      before do
        allow(building).to receive(:save!).and_raise(StandardError, 'Test error')
      end

      it 'returns error message' do
        expect(service.create_or_update).to eq ["Test error"]
      end

      it 'adds the error message to errors' do
        service.create_or_update
        expect(service.errors).to include('Test error')
      end
    end
  end
end