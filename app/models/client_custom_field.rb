class ClientCustomField < ApplicationRecord
  belongs_to :client
  has_many :building_custom_field_values, dependent: :destroy

  enum field_type: %i(numeric freeform list)

  validates :field_name, :field_type, presence: true
  validates :field_values, presence: true, if: :enum_field_type?


  private
  def enum_field_type?
    field_type == "list"
  end
end
