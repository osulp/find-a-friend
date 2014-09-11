class RenameLocationInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :location, :location_id
  end
end
