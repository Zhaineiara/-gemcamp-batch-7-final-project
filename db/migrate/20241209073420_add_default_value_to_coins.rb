class AddDefaultValueToCoins < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :coins, from: nil, to: 0
  end
end
