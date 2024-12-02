class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offer, null: false, foreign_key: true
      t.string :serial_number
      t.string :state
      t.decimal :amount
      t.integer :coin
      t.text :remarks
      t.integer :genre

      t.timestamps
    end
  end
end
