class Item < ApplicationRecord
  include AASM

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

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, guard: :can_start?, after: :perform_start_actions
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def can_start?
    quantity > 0 && Time.current < offline_at && active?
  end

  def perform_start_actions
    revise_batch_count
    deduct_quantity
  end

  def revise_batch_count
    update(batch_count: batch_count + 1)
  end

  def deduct_quantity
    update(quantity: quantity - 1)
  end
end
