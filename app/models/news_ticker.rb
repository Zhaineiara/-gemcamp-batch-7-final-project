class NewsTicker < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  belongs_to :admin, class_name: 'User', foreign_key: 'admin_id'

  validates :sort, uniqueness: false, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: false
  validates :content, presence: true

  enum status: { inactive: 0, active: 1, }

  def destroy
    update(deleted_at: Time.current)
  end
end
