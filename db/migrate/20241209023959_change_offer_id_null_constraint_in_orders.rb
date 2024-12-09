class ChangeOfferIdNullConstraintInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_null :orders, :offer_id, true
  end
end
