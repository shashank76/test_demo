class CreateClientCustomFields < ActiveRecord::Migration[6.0]
  def change
    create_table :client_custom_fields do |t|
      t.string :field_name, null: false
      t.integer :field_type, null: false, default: 0
      t.string :field_values, array: true, default: []
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
