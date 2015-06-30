class AddTemplateRefToReports < ActiveRecord::Migration
  def change
  	remove_column :reports, :template_name
  	remove_column :reports, :participants
  	remove_column :reports, :template
  	add_column :reports, :sections, :text
  end
end
