class CreateWinners < ActiveRecord::Migration[7.0]
  def change
    create_table :winners do |t|
      t.references :item, null: false, foreign_key: true
      t.references :ticket, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :address, null: false, foreign_key: { to_table: :user_addresses }
      t.integer :item_batch_count, null: false
      t.string :state
      t.decimal :price, precision: 10, scale: 2, null: false
      t.datetime :paid_at
      t.references :admin, foreign_key: { to_table: :users }
      t.string :picture
      t.text :comment

      t.timestamps
    end
  end
end
