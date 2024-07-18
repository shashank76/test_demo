FactoryBot.define do
  factory :client_custom_field do
    field_name { "Custom Field 1" }
    field_type { "freeform" }
    association :client
  end
end