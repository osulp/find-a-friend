class CreateTableAbout < ActiveRecord::Migration
  def change
    create_table :table_about do |t|
      t.text :about
    end
  end
end
