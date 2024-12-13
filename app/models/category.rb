class Category < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :name, presence: true
  validates :sort, uniqueness: false, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: false

  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end
end
