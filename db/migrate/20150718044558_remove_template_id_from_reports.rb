class RemoveTemplateIdFromReports < ActiveRecord::Migration
  def change
  	remove_column :reports, :template_id
  	remove_column :sections, :report_id
  	remove_column :templates, :sections
  end
end
