class ChangeGlyphiconTypeInFields < ActiveRecord::Migration
  def change
  	change_column :fields, :glyphicon, :text
  end
end
