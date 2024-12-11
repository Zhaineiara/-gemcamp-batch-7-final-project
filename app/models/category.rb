class Category < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :name, presence: true

  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end
end
