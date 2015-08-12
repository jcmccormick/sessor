json.(@template, :id, :creator_uid, :name, :draft, :sections, :columns, :private_world, :private_group, :group_id, :group_edit, :group_editors)

json.fields template.fields do |field|
	
	json.id field.id
	json.name field.name
	json.section_id field.section_id
	json.column_id field.column_id
	json.fieldtype field.fieldtype
	json.required field.required
	json.disabled field.disabled

	json.values field.values do |value|
		json.id value.id
		json.input value.input
		json.field_id value.field_id
	end

	json.options field.options do |option|
		json.id option.id
		json.name option.name
	end

end