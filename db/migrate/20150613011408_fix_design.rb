class FixDesign < ActiveRecord::Migration
  def change
  	rename_column :templates, :design, :sections
  end
end
