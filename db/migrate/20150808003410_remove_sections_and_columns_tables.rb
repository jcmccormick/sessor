class RemoveSectionsAndColumnsTables < ActiveRecord::Migration
  def change
  	drop_table :sections
  	drop_table :columns
  	remove_column :templates, :allow_title
  end
end
