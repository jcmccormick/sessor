class AddReportsValuesRelationship < ActiveRecord::Migration
  def change
  	add_column :values, :report_id, :integer
  	add_index :values, :report_id
  end
end
