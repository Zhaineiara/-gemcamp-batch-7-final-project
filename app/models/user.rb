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
  validates :phone, presence: true

  enum role: { client: 0, admin: 1 }
  mount_uploader :avatar, AvatarUploader

  has_many :user_addresses, dependent: :destroy
end
