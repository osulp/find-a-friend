class CreateAbouts < ActiveRecord::Migration
  def change
    create_table :abouts do |t|
      t.text :about_text
      t.timestamps
    end
  end
end
