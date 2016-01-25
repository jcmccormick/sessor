class CreateAdminsTemplatesJoinTable < ActiveRecord::Migration
  def change    
  	create_table :admins_templates, id: false do |t|
      t.integer :admin_id
      t.integer :template_id
    end
 
    add_index :admins_templates, :admin_id
    add_index :admins_templates, :template_id
  end
end
