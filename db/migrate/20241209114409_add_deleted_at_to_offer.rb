class AddDeletedAtToOffer < ActiveRecord::Migration[7.0]
  def change
    add_column :offers, :deleted_at, :datetime, default: nil
  end
end
