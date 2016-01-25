class AddWorksheetUrlToTemplates < ActiveRecord::Migration
  def change
  	add_column :templates, :gs_url, :string
  end
end
