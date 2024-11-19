class CreateItemCategoryShips < ActiveRecord::Migration[7.0]
  def change
    create_table :item_category_ships do |t|
      t.references :item, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
