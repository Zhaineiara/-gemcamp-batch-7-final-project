class UserAddress < ApplicationRecord
  belongs_to :user
  belongs_to :region, class_name: 'Address::Region', optional: true
  belongs_to :province, class_name: 'Address::Province', optional: true
  belongs_to :city, class_name: 'Address::City', optional: true
  belongs_to :barangay, class_name: 'Address::Barangay', optional: true

  enum genre: { home: 0, office: 1 }

  validates :name, :street_address, :phone_number, presence: true
  validates :is_default, inclusion: { in: [true, false] }

  validate :max_address_limit, on: :create

  private

  def max_address_limit
    if user && user.user_addresses.count >= 5
      errors.add(:user, "can only have up to 5 addresses")
    end
  end
end
