class AddReportFieldsRelationship < ActiveRecord::Migration
  def change
  	add_column :fields, :report_id, :integer
  	add_index :fields, :report_id
  end
end
