class Item < ApplicationRecord
  include AASM
  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships
  has_many :tickets

  validates :name, :quantity, :minimum_tickets, :batch_count, presence: true
  validates :quantity, :minimum_tickets, :batch_count, numericality: { greater_than_or_equal_to: 0 }

  enum status: { inactive: 0, active: 1 }
  mount_uploader :item_image, ItemImageUploader

  def destroy
    update(deleted_at: Time.current)
  end

  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, guard: :start_validation, after: :perform_start_actions
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, after: :pick_winner
    end

    event :cancel do
      transitions from: [:starting, :paused], to: :cancelled, after: :cancel_associated_tickets
    end
  end

  private

  def start_validation
    quantity > 0 && Date.today < offline_at && active?
  end

  def perform_start_actions
    add_batch_count
    deduct_quantity
  end

  def add_batch_count
    update(batch_count: batch_count + 1)
  end

  def deduct_quantity
    update(quantity: quantity - 1)
  end

  def cancel_associated_tickets
    tickets.pending.each do |ticket|
      ticket.cancel!
      ticket.save
    end
  end

  def pick_winner
    current_batch_tickets = tickets.where(batch_count: batch_count)
    return if current_batch_tickets.empty?

    winning_ticket = current_batch_tickets.sample

    current_batch_tickets.each do |ticket|
      ticket.lose! unless ticket == winning_ticket
    end
    winning_ticket.win!

    default_address = winning_ticket.user.default_address

    if self.is_a?(Item)
      Winner.create!(
        item_id: self.id,
        ticket: winning_ticket,
        user: winning_ticket.user,
        address_id: default_address&.id,
        item_batch_count: batch_count,
        state: 'won',
        price: nil,
        paid_at: nil
      )
    else
      raise "Invalid item type: #{self.class.name}"
    end
  end
end
