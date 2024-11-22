class Category < ApplicationRecord
  default_scope { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  validates :name, presence: true, uniqueness: { case_sensitive: false, message: "Category with this name already exists." }

  has_many :item_category_ships
  has_many :items, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end
end
