require 'rails_helper'

RSpec.describe ClientCustomField, type: :model do
  context 'associations' do
    it { should belong_to(:client) }
    it { should have_many(:building_custom_field_values).dependent(:destroy) }
  end
  
  context 'validation' do
    it { should define_enum_for(:field_type).with_values(%i(numeric freeform list)) }
    it { should validate_presence_of(:field_name) }
    it { should validate_presence_of(:field_type) }
  end

  context 'when field_type is list' do
    before { allow(subject).to receive(:enum_field_type?).and_return(true) }
    it { should validate_presence_of(:field_values) }
  end

  context 'when field_type is not list' do
    before { allow(subject).to receive(:enum_field_type?).and_return(false) }
    it { should_not validate_presence_of(:field_values) }
  end

  describe '#enum_field_type?' do
    let(:client_custom_field) { ClientCustomField.new(field_type: field_type) }

    context 'when field_type is list' do
      let(:field_type) { 'list' }

      it 'returns true' do
        expect(client_custom_field.send(:enum_field_type?)).to be true
      end
    end

    context 'when field_type is not list' do
      let(:field_type) { 'numeric' }

      it 'returns false' do
        expect(client_custom_field.send(:enum_field_type?)).to be false
      end
    end
  end
end
