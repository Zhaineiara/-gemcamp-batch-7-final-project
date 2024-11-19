class Item < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true
  validates :quantity, :minimum_tickets, :batch_count, numericality: { greater_than_or_equal_to: 0 }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :item_image, ItemImageUploader

  def destroy
    update(deleted_at: Time.current)
  end

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
end
