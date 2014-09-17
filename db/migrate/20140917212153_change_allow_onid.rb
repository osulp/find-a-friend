class ChangeAllowOnid < ActiveRecord::Migration
  def change
    change_column :posts, :allow_onid, :boolean, :default => true
  end
end
