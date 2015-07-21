class FixReportTemplateRelationship < ActiveRecord::Migration
  def change
  	remove_column :reports, :sections
  	remove_column :sections, :report_id
  	create_table :reports_templates, id: false do |t|
  		t.integer :report_id
  		t.integer :template_id
  	end

  	add_index :reports_templates, :report_id
  	add_index :reports_templates, :template_id
  end
end
