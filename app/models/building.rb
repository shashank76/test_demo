class Building < ApplicationRecord
  belongs_to :client
  has_many :building_custom_field_values, dependent: :destroy

  validates :address, :state, :zip, presence: true

  accepts_nested_attributes_for :building_custom_field_values, allow_destroy: true

  def update_building_custom_field_values(attributes)
    self.update(attributes)
    if attributes[:building_custom_field_values_attributes].present?
      attributes[:building_custom_field_values_attributes].each do |attr|
        client_custom_field_id = attr[:client_custom_field_id]
        building_custom_field_value = self.building_custom_field_values.find_or_initialize_by(client_custom_field_id: client_custom_field_id)
        if building_custom_field_value.persisted?
          building_custom_field_value.update(value: attr[:value])
        else
          building_custom_field_value.assign_attributes(attr)
          building_custom_field_value.save
        end
      end
    end
  end
end