class AllowNullAddressIdInWinners < ActiveRecord::Migration[7.0]
  def change
    change_column_null :winners, :address_id, true
  end
end
