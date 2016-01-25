class AddSpreadsheetIdToTemplates < ActiveRecord::Migration
  def change
  	add_column :templates, :gs_id, :string
  end
end
