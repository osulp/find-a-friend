class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :onid

      t.timestamps
    end
  end
end
