class Category < ApplicationRecord
  validates :name, presence: true

  has_many :item_category_ships
  has_many :items, through: :post_category_ships
end
