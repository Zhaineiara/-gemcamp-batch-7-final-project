class AddForeignKeyToUsersParentId < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :users, :users, column: :parent_id
  end
end
