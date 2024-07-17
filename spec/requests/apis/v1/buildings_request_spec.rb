require 'rails_helper'

RSpec.describe "Apis::V1::Buildings", type: :request do
  describe "GET /apis/v1/buildings" do
    it "returns http success" do
      get "/apis/v1/buildings"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /apis/v1/buildings" do
    let(:client) { create(:client) }
    let(:client_custom_field) { create(:client_custom_field) }
    let(:valid_attributes) do
      {
        'building' => {
          'address' => '123 Main St',
          'state' => 'NY',
          'zip' => '10001',
          'client_id' => client.id,
          'building_custom_field_values_attributes': [
            { 'client_custom_field_id': client_custom_field.id, 'value': 'Updated Value' }
          ]
        }
      }
    end

    it "creates a new building" do
      expect {
        post "/apis/v1/buildings", params: valid_attributes
      }.to change(Building, :count).by(1)
      
      expect(response).to have_http_status(:created)
    end
  end

  describe "PUT /apis/v1/buildings/:id" do
    let(:client) { create(:client) }
    let(:building) { create(:building) }
    let(:client_custom_field) { create(:client_custom_field) }
    let(:building_custom_field_vals) { create(:building_custom_field_value, building: building, client_custom_field: client_custom_field) }
    let(:valid_attributes) do
      {
        'building' => {
          'address' => 'Updated Address',
          'state' => 'Test',
          'zip' => '12345',
          'client_id' => client.id,
          'building_custom_field_values_attributes': [
            { 'client_custom_field_id': client_custom_field.id, 'value': 'Updated Value' }
          ]
        }
      }
    end

    it "updates the building" do
      patch "/apis/v1/buildings/#{building.id}", params: valid_attributes
      expect(response).to have_http_status(:ok)
    end
  end
end
