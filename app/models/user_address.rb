class UserAddress < ApplicationRecord
  before_save :single_default_validation, if: :is_default?

  belongs_to :user
  belongs_to :region, class_name: 'Address::Region'
  belongs_to :province, class_name: 'Address::Province'
  belongs_to :city, class_name: 'Address::City'
  belongs_to :barangay, class_name: 'Address::Barangay'

  validates :is_default, inclusion: { in: [true, false] }
  validates :name, :street_address, :phone_number, presence: true
  validate :max_address_limit, on: :create
  validates :phone_number, phone: { possible: true, allow_blank: true, types: %i[voip mobile], countries: [:ph] }

  enum genre: { home: 0, office: 1 }

  private

  def max_address_limit
    if user && user.user_addresses.count >= 5
      errors.add(:user, "can only have up to 5 addresses")
    end
  end

  def single_default_validation
    if is_default && user.user_addresses.where(is_default: true).exists?
      user.user_addresses.where(is_default: true).update_all(is_default: false)
    end
  end
end