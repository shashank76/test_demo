class ClientCustomField < ApplicationRecord
  #associations
  belongs_to :client
  has_many :building_custom_field_values, dependent: :destroy

  # custom field type enum values, using 'list' as name for enum type custom field type (given in document)
  # because enum is reserved keyword
  enum field_type: %i(numeric freeform list)

  #validations
  validates :field_name, :field_type, presence: true
  validates :field_values, presence: true, if: :enum_field_type?

  private
  # validatin for field value when selected list to set list of values for selection options
  def enum_field_type?
    field_type == "list"
  end
end
