class RenameTypeInFields < ActiveRecord::Migration
  def change
  	rename_column :fields, :type, :datatype
  end
end
