class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :phone, phone: {
    possible: true,
    allow_blank: true,
    types: %i[voip mobile],
    countries: [:ph]
  }

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :username, presence: true

  enum role: { client: 0, admin: 1 }
  mount_uploader :avatar, AvatarUploader

  has_many :user_addresses, dependent: :destroy
  has_many :address_regions, through: :addresses
  has_many :address_provinces, through: :addresses
  has_many :address_cities, through: :addresses
  has_many :address_barangays, through: :addresses

  belongs_to :parent, class_name: User.name, foreign_key: :parent_id, counter_cache: :children_members, optional: true
  has_many :children, class_name: User.name, foreign_key: :parent_id, dependent: :destroy
  has_many :tickets
end
