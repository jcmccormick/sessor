class AddReportSectionsRelationship2 < ActiveRecord::Migration
  def change
  	add_column :sections, :report_id, :integer
  	add_index :sections, :report_id
  end
end
