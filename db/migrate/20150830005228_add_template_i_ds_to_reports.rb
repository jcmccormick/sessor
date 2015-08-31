class AddTemplateIDsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :template_ids, :text
  end
end
