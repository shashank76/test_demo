FactoryBot.define do
  factory :building do
    address { "123 Main St" }
    state { "NY" }
    zip { "10001" }
    
    association :client
  end
end