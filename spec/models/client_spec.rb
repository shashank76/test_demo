require 'rails_helper'

RSpec.describe Client, type: :model do
  context 'associations' do
    it { should have_many(:buildings).dependent(:destroy) }
    it { should have_many(:client_custom_fields).dependent(:destroy) }
  end

  context 'validations' do
    it { should validate_presence_of(:name) }
  end
end
