class Building < ApplicationRecord
  #associations
  belongs_to :client
  has_many :building_custom_field_values, dependent: :destroy, inverse_of: :building

  #validations
  validates :address, :state, :zip, presence: true
end