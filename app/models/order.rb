class Order < ApplicationRecord
  include AASM

  before_create :generate_serial_number
  after_create :update_serial_number

  validates :state, :genre, presence: true
  validates :offer_id, presence: true, if: -> { genre == "deposit" }
  validates :serial_number, presence: true, uniqueness: true, on: :update
  validates :amount, presence: true, if: -> { genre == "deposit" }
  validates :amount, numericality: { greater_than: 0 }, if: -> { genre == "deposit" }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :remarks, length: { maximum: 500 }, allow_blank: true

  belongs_to :user
  belongs_to :offer, optional: true

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, after: :handle_cancelled_state
    end

    event :pay do
      transitions from: :submitted, to: :paid, after: :handle_paid_state
      transitions from: :pending, to: :paid, if: :can_transition_to_paid?, after: :handle_paid_state
    end
  end

  private
  def generate_serial_number
    self.serial_number = "TEMPORARY"
  end

  def update_serial_number
    # After the order is saved and has an id, update the serial number
    number_count = format('%04d', Order.where(user_id: user_id).count)
    self.update_column(:serial_number, "#{Time.current.strftime('%y%m%d')}-#{self.id}-#{user_id}-#{number_count}")
  end

  def increase_coins
    user.update(coins: user.coins + coin)
  end

  def decrease_coins
    if user.coins >= coin
      user.update(coins: user.coins - coin)
    else
      errors.add(:base, "Not enough coins to deduct.")
      raise ActiveRecord::Rollback
    end
  end

  def decrease_coins_if_not_deduct
    return if genre == "deduct"
    decrease_coins
  end

  def increase_coins_if_deduct
    return unless genre == "deduct"
    increase_coins
  end

  def increase_total_deposit
    return unless genre == "deposit"
    user.update(total_deposit: user.total_deposit + amount)
  end

  def decrease_total_deposit_if_deposit
    return unless genre == "deposit"
    if user.total_deposit >= amount
      user.update(total_deposit: user.total_deposit - amount)
    else
      errors.add(:base, "Not enough total deposit to deduct.")
      raise ActiveRecord::Rollback
    end

  end

  def handle_paid_state
    increase_coins unless genre == "deduct"
    decrease_coins if genre == "deduct"
    increase_total_deposit
  end

  def handle_cancelled_state
    decrease_coins_if_not_deduct
    increase_coins_if_deduct
    decrease_total_deposit_if_deposit
  end

  def can_transition_to_paid?
    ['increase', 'deduct', 'bonus', 'share'].include?(genre)
  end
end
