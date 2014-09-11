class ChangeLocationIdInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :location_id, :location
    change_column :posts, :location, :string
  end
end
