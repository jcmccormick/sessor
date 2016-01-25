class AddSectionIdToFields < ActiveRecord::Migration
  def change
  	add_column :fields, :section_id, :integer
  	add_column :fields, :template_id, :integer
  	add_column :templates, :sections, :text
  	add_column :templates, :columns, :text

  	add_index :fields, :template_id

  end
end
