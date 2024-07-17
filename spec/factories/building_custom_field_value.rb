FactoryBot.define do
  factory :building_custom_field_value do
    association :building
    association :client_custom_field
    value { 'Test Value' }
  end
end