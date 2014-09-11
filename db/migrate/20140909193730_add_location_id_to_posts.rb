class AddLocationIdToPosts < ActiveRecord::Migration
  def change
    change_column :posts, :location, :integer
    add_index :posts, :location
  end
end
