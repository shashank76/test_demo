require 'rails_helper'

RSpec.describe BuildingCustomFieldValue, type: :model do
  context 'associations' do
    it { should belong_to(:building) }
    it { should belong_to(:client_custom_field) }
  end

  context 'validations' do
    it { should validate_presence_of(:value) }
    let(:building) { create(:building) }
    let(:client_custom_field) { create(:client_custom_field) }
    let(:building_custom_fields) { build(:building_custom_field_value, building: building, client_custom_field: client_custom_field) }

    before do
      building_custom_fields.validate
    end

    context 'when field_type is numeric' do
      before do
        client_custom_field.update(field_type: 'numeric')
      end

      it 'validates value as a decimal number' do
        building_custom_fields.value = '2.5'
        building_custom_fields.validate
        expect(building_custom_fields.errors[:value]).to be_empty
      end

      it 'adds error if value is not a decimal number' do
        building_custom_fields.value = 'abc'
        building_custom_fields.validate
        expect(building_custom_fields.errors[:value]).to include('must be a decimal number')
      end
    end

    context 'when field_type is list' do
      let(:allowed_values) { ['Option 1', 'Option 2', 'Option 3'] }

      before do
        client_custom_field.update(field_type: 'list', field_values: allowed_values)
      end

      it 'validates value against allowed values' do
        building_custom_fields.value = 'Option 1'
        building_custom_fields.validate
        expect(building_custom_fields.errors[:value]).to be_empty
      end

      it 'adds error if value is not in allowed values' do
        building_custom_fields.value = 'Invalid Option'
        building_custom_fields.validate
        expect(building_custom_fields.errors[:value]).to include('must match one of the allowed values')
      end
    end
  end
end
