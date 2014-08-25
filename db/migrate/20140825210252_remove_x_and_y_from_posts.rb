class RemoveXAndYFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :x, :integer
    remove_column :posts, :y, :integer
  end
end
