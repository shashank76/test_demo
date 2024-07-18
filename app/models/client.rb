class Client < ApplicationRecord
  #validations
  validates :name, presence: true

  #associations
  has_many :buildings, dependent: :destroy
  has_many :client_custom_fields, dependent: :destroy
end
