json.(@template, :id, :name, :draft, :private_world, :private_group, :group_id, :group_edit, :group_editors, :sections)

json.fields template.fields do |field|
	
	json.id field.id
	json.section_id field.section_id
	json.column_id field.column_id
	json.column_order field.column_order
	json.fieldtype field.fieldtype
	json.glyphicon field.glyphicon
	if field.default_value.present?
		json.default_value field.default_value
	end
	if field.name.present?
		json.name field.name
	end
	if field.placeholder.present?
		json.placeholder field.placeholder
	end
	if field.tooltip.present?
		json.tooltip field.tooltip
	end
	if field.required.present?
		json.required field.required
	end
	if field.disabled.present?
		json.disabled field.disabled
	end
	if field.options.present?
		json.options field.options
	end
end