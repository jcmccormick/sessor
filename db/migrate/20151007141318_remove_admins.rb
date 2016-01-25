class RemoveAdmins < ActiveRecord::Migration
  def change
  	drop_table :admins
  	drop_table :options
  end
end
