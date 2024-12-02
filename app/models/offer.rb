class Offer < ApplicationRecord
  validates :image,:status, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99999999.99 }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :image, OfferImageUploader
end
