class AddDefaultValueToTotalDeposit < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :total_deposit, from: nil, to: 0
  end
end
