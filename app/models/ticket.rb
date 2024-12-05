class Ticket < ApplicationRecord
  include AASM

  before_create :deduct_coins
  before_create :generate_serial_number
  before_destroy :refund_coins

  belongs_to :user
  belongs_to :item
  belongs_to :winner

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :refund_coins
    end
  end

  private

  def refund_coins
    Rails.logger.debug "Refunding coins for user #{user.id} and ticket #{id}"
    user.update!(coins: user.coins + coins)
  end

  def deduct_coins
    user.update!(coins: user.coins - coins)
  end

  def generate_serial_number
    number_count = nil
    Ticket.transaction do
      number_count = Ticket.where(item_id: item.id, batch_count: item.batch_count).lock(true).count + 1
    end
    number_count = number_count.to_s.rjust(4, '0')
    self.serial_number = "#{Time.current.strftime('%y%m%d')}-#{item.id}-#{item.batch_count}-#{number_count}"
  end
end