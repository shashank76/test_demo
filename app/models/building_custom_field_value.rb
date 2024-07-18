class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building, inverse_of: :building_custom_field_values
  belongs_to :client_custom_field

  validates_presence_of :value
  validate :validate_value_based_on_field_type

  private

  def validate_value_based_on_field_type
    return if client_custom_field.nil?

    case client_custom_field.field_type
    when 'numeric'
      errors.add(:value, 'must be a decimal number') unless value =~ /\A[+]?([0-9]+(\.[0-9]+)?)\Z/
    when 'list'
      allowed_values = client_custom_field.field_values.map(&:strip)
      errors.add(:value, 'must match one of the allowed values') unless allowed_values.include?(value)
    end
  end
end
