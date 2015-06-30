class RenameNameToTitleInReports < ActiveRecord::Migration
  def change
  	rename_column :reports, :name, :title
  end
end
