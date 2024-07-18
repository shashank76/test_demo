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
  end
end
