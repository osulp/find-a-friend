class AddPhotoToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :photo, :string
  end
end
