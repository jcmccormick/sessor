class AddGlyphiconToFields < ActiveRecord::Migration
  def change
  	add_column :fields, :glyphicon, :string
  end
end
