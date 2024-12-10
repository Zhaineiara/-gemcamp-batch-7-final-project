class Banner < ApplicationRecord
  default_scope { where(deleted_at: nil) }

  validates :preview, :online_at, :offline_at, :status, presence: true
  enum status: { inactive: 0, active: 1 }
  mount_uploader :preview, PreviewUploader

  def destroy
    update(deleted_at: Time.now)
  end
end
