class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.string :name
      t.string :street_address
      t.string :phone_number
      t.string :remark
      t.boolean :is_default
      t.references :user, null: false, foreign_key: true
      t.integer :region_id
      t.integer :province_id
      t.integer :city_id
      t.integer :barangay_id
      t.integer :genre

      t.timestamps
    end
  end
end
