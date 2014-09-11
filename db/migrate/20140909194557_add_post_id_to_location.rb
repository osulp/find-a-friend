class AddPostIdToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :post_id, :integer
    add_index :locations, :post_id
  end
end
