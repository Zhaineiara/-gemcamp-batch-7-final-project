class Order < ApplicationRecord
  before_create :generate_serial_number

  validates :offer_id, :state, :genre, presence: true
  validates :serial_number, presence: true, uniqueness: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :coin, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :remarks, length: { maximum: 500 }, allow_blank: true

  belongs_to :user
  belongs_to :offer

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  def generate_serial_number
    number_count = format('%04d', Order.where(user_id: user_id).count + 1)
    self.serial_number = "#{Time.current.strftime('%y%m%d')}-#{id}-#{user_id}-#{number_count}"
  end
end
