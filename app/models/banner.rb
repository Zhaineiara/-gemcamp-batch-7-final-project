class Banner < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :preview, :online_at, :offline_at, :status, presence: true
  validates :sort, uniqueness: false, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, presence: false

  enum status: { inactive: 0, active: 1 }
  mount_uploader :preview, PreviewUploader

  def destroy
    update(deleted_at: Time.now)
  end

  private

  def check_date
    if online_at < offline_at
      true
    else
      errors.add(:base, "Check the online at or the offline at")
      throw(:abort)
      false
    end
  end
end
