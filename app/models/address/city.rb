class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province, optional: true
  has_many :barangays
  has_many :user_addresses
end