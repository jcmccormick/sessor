class AddDbRelationships < ActiveRecord::Migration
  def change
  	add_column :reports, :admin_id, :integer
  	add_index :reports, :admin_id
  	add_column :templates, :admin_id, :integer
  	add_column :templates, :report_id, :integer
  	add_index :templates, :admin_id
  	add_index :templates, :report_id
  	add_column :users, :group_id, :integer
  	add_index :users, :group_id
  end
end
