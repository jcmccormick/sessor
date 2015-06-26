class FixDbRelationships < ActiveRecord::Migration
  def change
    remove_column :reports, :admin_id
    remove_column :templates, :admin_id

    create_table :admins_reports, id: false do |t|
      t.integer :admin_id
      t.integer :report_id
    end
 
    add_index :admins_reports, :admin_id
    add_index :admins_reports, :report_id
  end
end
