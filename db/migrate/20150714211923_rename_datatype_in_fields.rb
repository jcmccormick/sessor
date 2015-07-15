class RenameDatatypeInFields < ActiveRecord::Migration
  def change
  	rename_column :fields, :datatype, :fieldtype
  	change_column :fields, :glyphicon, :string
  end
end
