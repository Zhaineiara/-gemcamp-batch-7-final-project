class User < ApplicationRecord
  belongs_to :parent, class_name: User.name, foreign_key: :parent_id, counter_cache: :children_members, optional: true
  has_many :user_addresses, dependent: :destroy
  has_many :address_regions, through: :user_addresses
  has_many :address_provinces, through: :user_addresses
  has_many :address_cities, through: :user_addresses
  has_many :address_barangays, through: :user_addresses
  has_many :children, class_name: User.name, foreign_key: :parent_id, dependent: :destroy
  has_many :news_tickers
  has_many :orders
  has_many :tickets
  has_many :winners

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :firstname, :lastname, :username, presence: true
  validates :phone, phone: { possible: true, allow_blank: true, types: %i[voip mobile], countries: [:ph] }

  enum role: { client: 0, admin: 1 }
  mount_uploader :avatar, AvatarUploader

  def default_address
    user_addresses.find_by(is_default: true)
  end
end