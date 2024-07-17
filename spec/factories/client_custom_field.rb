FactoryBot.define do
  factory :client_custom_field do
    field_name { "Custom Field 1" }
    field_type { "freeform" }
    field_values { [] }
    association :client
  end
end