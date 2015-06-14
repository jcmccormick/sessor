class FixReportsTemplateType < ActiveRecord::Migration
  def change
  	  change_column :reports, :template, :text
  end
end
