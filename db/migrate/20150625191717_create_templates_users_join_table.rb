class CreateTemplatesUsersJoinTable < ActiveRecord::Migration
  def change
  	create_table :templates_users, id: false do |t|
  	  t.integer :user_id
  	  t.integer :template_id
  	end

  	add_index :templates_users, :user_id
  	add_index :templates_users, :template_id
  end
end
