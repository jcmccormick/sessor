class AddTemplateRelationships < ActiveRecord::Migration
  def change
	add_column :sections, :template_id, :integer
	add_index :sections, :template_id
	add_column :columns, :section_id, :integer
	add_index :columns, :section_id
	add_column :fields, :column_id, :integer
	add_index :fields, :column_id
  end
end
