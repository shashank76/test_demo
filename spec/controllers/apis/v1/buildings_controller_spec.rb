require 'rails_helper'

RSpec.describe Apis::V1::BuildingsController, type: :controller do
  describe 'GET #index' do
    let!(:client) { create(:client) }
    let!(:buildings) { create_list(:building, 3, client: client) }

    before do
      get :index, format: :json
    end

    it 'returns a successful response' do
      expect(response).to have_http_status(:ok)
    end

    it 'returns a list of buildings' do
      expect(JSON.parse(response.body)['buildings']).not_to be_empty
      expect(JSON.parse(response.body)['buildings'].size).to eq(3)
    end
  end

  describe 'POST #create' do
    let!(:client) { create(:client) }
    let(:client_custom_field1) { create(:client_custom_field) }
    let(:client_custom_field2) { create(:client_custom_field, field_name: "Test Field", field_type: 'freeform') }
    let(:valid_attributes) do
      {
        building: {
          address: '123 Test St',
          state: 'NY',
          zip: '100001',
          client_id: client.id,
          building_custom_field_values_attributes: [
            { client_custom_field_id: client_custom_field1.id, value: 'Value 1' },
            { client_custom_field_id: client_custom_field2.id, value: 'Value 2' }
          ]
        }
      }
    end

    context 'with valid attributes' do
      it 'creates a new building' do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(Building, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end

      it 'returns the created building' do
        post :create, params: valid_attributes, format: :json
        expect(JSON.parse(response.body)['building']['address']).to eq('123 Test St NY 100001')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        {
          building: {
            address: nil,
            state: 'IL',
            zip: '62704',
            client_id: client.id
          }
        }
      end

      it 'does not create a new building' do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.not_to change(Building, :count)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_attributes, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_attributes, format: :json
        expect(JSON.parse(response.body)).to include("Validation failed: Address can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    let!(:client) { create(:client) }
    let!(:building) { create(:building, client: client) }
    let(:client_custom_field1) { create(:client_custom_field) }
    let(:client_custom_field2) { create(:client_custom_field, field_name: "Test Field", field_type: 'freeform') }
    let(:valid_attributes) do
      {
        id: building.id,
        building: {
          address: '456 Updated St',
          state: 'NY',
          zip: '100001',
          client_id: client.id,
          building_custom_field_values_attributes: [
            { client_custom_field_id: client_custom_field1.id, value: 'Updated Value 1' },
            { client_custom_field_id: client_custom_field2.id, value: 'Updated Value 2' }
          ]
        }
      }
    end

    context 'with valid attributes' do
      it 'updates the building' do
        patch :update, params: valid_attributes, format: :json
        building.reload
        expect(building.address).to eq('456 Updated St')
      end

      it 'returns a success status' do
        patch :update, params: valid_attributes, format: :json
        expect(response).to have_http_status(:ok)
      end

      it 'returns the updated building' do
        patch :update, params: valid_attributes, format: :json
        expect(JSON.parse(response.body)['building']['address']).to eq('456 Updated St NY 100001')
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        {
          id: building.id,
          building: {
            address: nil,
            state: 'IL',
            zip: '62704',
            client_id: client.id
          }
        }
      end

      it 'does not update the building' do
        patch :update, params: invalid_attributes, format: :json
        building.reload
        expect(building.address).not_to be_nil
      end

      it 'returns an unprocessable entity status' do
        patch :update, params: invalid_attributes, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        patch :update, params: invalid_attributes, format: :json
        expect(JSON.parse(response.body)).to include("Validation failed: Address can't be blank")
      end
    end
  end
end
