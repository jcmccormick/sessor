class RenameTemplateIdsInReports < ActiveRecord::Migration
  def change
  	rename_column :reports, :template_ids, :template_order
  end
end
