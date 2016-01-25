class CreateReportsUsersJoinTable < ActiveRecord::Migration
  def change
  	create_table :reports_users, id: false do |t|
  	  t.integer :user_id
  	  t.integer :report_id
  	end

  	add_index :reports_users, :user_id
  	add_index :reports_users, :report_id
  end
end
