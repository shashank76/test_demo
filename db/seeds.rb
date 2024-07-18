# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creating 5 clients with only dummy names
client1 = Client.create!(name: 'John Doe')
client2 = Client.create!(name: 'Jane Doe')
client3 = Client.create!(name: 'Jack Doe')
client4 = Client.create!(name: 'Jill Doe')
client5 = Client.create!(name: 'Jim Doe')

# Creating Client's Custom Fields with client's id
client1_custom_field_1 = client1.client_custom_fields.create!(field_name: 'Number of bathrooms', field_type: 'numeric')
client1_custom_field_2 = client1.client_custom_fields.create!(field_name: 'Number of bedrooms', field_type: 'numeric')
client1_custom_field_3 = client1.client_custom_fields.create!(field_name: 'Living room color', field_type: 'freeform')
client1_custom_field_4 = client1.client_custom_fields.create!(
  field_name: 'Type of walkway', field_type: 'list', field_values: %w(Brick Concrete)
)
client2_custom_field_1 = client2.client_custom_fields.create!(field_name: 'Number of bathrooms', field_type: 'numeric')
client2_custom_field_2 = client2.client_custom_fields.create!(field_name: 'Number of bedrooms', field_type: 'numeric')
client2_custom_field_3 = client2.client_custom_fields.create!(field_name: 'Living room color', field_type: 'freeform')
client2_custom_field_4 = client2.client_custom_fields.create!(
  field_name: 'Type of wall', field_type: 'list', field_values: %w(Brick Concrete)
)
client3_custom_field_1 = client3.client_custom_fields.create!(field_name: 'Number of bathrooms', field_type: 'numeric')
client3_custom_field_2 = client3.client_custom_fields.create!(field_name: 'Number of bedrooms', field_type: 'numeric')
client3_custom_field_3 = client3.client_custom_fields.create!(field_name: 'Interior Color', field_type: 'freeform')
client4_custom_field_1 = client4.client_custom_fields.create!(field_name: 'Number of bathrooms', field_type: 'numeric')
client4_custom_field_2 = client4.client_custom_fields.create!(field_name: 'Wall Color', field_type: 'freeform')
client4_custom_field_3 = client4.client_custom_fields.create!(field_name: 'Number of bedrooms', field_type: 'numeric')
client5_custom_field_1 = client5.client_custom_fields.create!(field_name: 'Number of bathrooms', field_type: 'numeric')
client5_custom_field_2 = client5.client_custom_fields.create!(field_name: 'Number of bedrooms', field_type: 'numeric')
client5_custom_field_3 = client5.client_custom_fields.create!(field_name: 'Wall size', field_type: 'numeric')
client5_custom_field_4 = client5.client_custom_fields.create!(field_name: 'Wall Color', field_type: 'freeform')
client5_custom_field_5 = client5.client_custom_fields.create!(
  field_name: 'House Type', field_type: 'list', field_values: %w(Townhouse Highrise Apartment Flat)
)


# Creating Buildings with building custom fields values
client1.buildings.create!(
  address: "123 Main St", state: "NY", zip: "10001",
  building_custom_field_values_attributes: [
    { client_custom_field: client1_custom_field_1, value: "2" },
    { client_custom_field: client1_custom_field_2, value: "2" },
    { client_custom_field: client1_custom_field_3, value: "Blue" },
    { client_custom_field: client1_custom_field_4, value: "Brick" }
  ]
)
client2.buildings.create!(
  address: "456 Elm St", state: "NY", zip: "10002",
  building_custom_field_values_attributes: [
    { client_custom_field: client2_custom_field_1, value: "2" },
    { client_custom_field: client2_custom_field_2, value: "3" },
    { client_custom_field: client2_custom_field_3, value: "Light Blue" },
    { client_custom_field: client2_custom_field_4, value: "Concrete" }
  ]
)
client3.buildings.create!(
  address: "234 Main St", state: "NY", zip: "10001",
  building_custom_field_values_attributes: [
    { client_custom_field: client3_custom_field_1, value: "2" },
    { client_custom_field: client3_custom_field_2, value: "2" },
    { client_custom_field: client3_custom_field_3, value: "White" },
  ]
)
client4.buildings.create!(
  address: "345 Main St", state: "NY", zip: "10001",
  building_custom_field_values_attributes: [
    { client_custom_field: client4_custom_field_1, value: "2" },
    { client_custom_field: client4_custom_field_2, value: "Gray" },
    { client_custom_field: client4_custom_field_3, value: "2" },
  ]
)
client5.buildings.create!(
  address: "567 Main St", state: "NY", zip: "10001",
  building_custom_field_values_attributes: [
    { client_custom_field: client5_custom_field_1, value: "2" },
    { client_custom_field: client5_custom_field_2, value: "3" },
    { client_custom_field: client5_custom_field_3, value: "17" },
    { client_custom_field: client5_custom_field_4, value: "White" },
    { client_custom_field: client5_custom_field_5, value: "Apartment" }
  ]
)
client5.buildings.create!(
  address: "136 freedom St", state: "NY", zip: "10005",
  building_custom_field_values_attributes: [
    { client_custom_field: client5_custom_field_1, value: "1" },
    { client_custom_field: client5_custom_field_2, value: "2" },
    { client_custom_field: client5_custom_field_4, value: "Light Gray" },
    { client_custom_field: client5_custom_field_5, value: "Townhouse" }
  ]
)