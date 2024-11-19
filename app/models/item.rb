class Item < ApplicationRecord
  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true
  validates :quantity, :minimum_tickets, :batch_count, numericality: { greater_than_or_equal_to: 0 }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :item_image, ItemImageUploader
end
