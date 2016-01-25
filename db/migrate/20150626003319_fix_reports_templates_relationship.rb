class FixReportsTemplatesRelationship < ActiveRecord::Migration
  def change
  	remove_column :templates, :report_id
  	add_index :reports, :template_id
  end
end
