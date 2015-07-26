class AddAllowTitleToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :allow_title, :boolean
  end
end
