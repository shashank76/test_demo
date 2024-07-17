class Client < ApplicationRecord
  #Validations
  validates :name, presence: true

  #Associations
  has_many :buildings, dependent: :destroy
  has_many :client_custom_fields, dependent: :destroy
end
