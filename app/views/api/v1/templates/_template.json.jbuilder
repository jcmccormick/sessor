json.(@template, :id, :name, :draft, :private_world, :private_group, :group_id, :group_edit, :group_editors, :sections, :columns)

json.fields template.fields do |field|
	
	json.id field.id
	json.name field.name
	json.section_id field.section_id
	json.column_id field.column_id
	json.column_order field.column_order
	json.fieldtype field.fieldtype
	json.required field.required
	json.disabled field.disabled
	json.default_value field.default_value
	json.options field.options

end