class DropTableAboutTable < ActiveRecord::Migration
  def change
    drop_table :table_about, {}
  end
end
