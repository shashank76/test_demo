require 'rails_helper'

RSpec.describe Building, type: :model do
  context 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:building_custom_field_values).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:address) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:zip) }
  end

  context 'nested attributes' do
    it 'accepts nested attributes for building_custom_field_values' do
      should accept_nested_attributes_for(:building_custom_field_values).allow_destroy(true)
    end
  end

  describe '#update_building_custom_field_values' do
    let(:client) { FactoryBot.create(:client) }
    let(:building) { FactoryBot.create(:building, client: client) }
    let(:client_custom_field) { FactoryBot.create(:client_custom_field) }
    let(:attributes) do
      {
        address: '123 Main St',
        state: 'NY',
        zip: '10001',
        building_custom_field_values_attributes: [
          { client_custom_field_id: client_custom_field.id, value: 'New Value' }
        ]
      }
    end

    it 'updates or creates building custom field values' do
      building.update_building_custom_field_values(attributes)

      expect(building.address).to eq('123 Main St')
      expect(building.state).to eq('NY')
      expect(building.zip).to eq('10001')

      building_custom_field_value = building.building_custom_field_values.find_by(client_custom_field_id: client_custom_field.id)
      expect(building_custom_field_value).to be_present
      expect(building_custom_field_value.value).to eq('New Value')
    end
  end
end
