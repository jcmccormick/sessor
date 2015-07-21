class RemoveReportsSectionsRelationship < ActiveRecord::Migration
  def change
  	remove_column :sections, :report_id
  end
end
