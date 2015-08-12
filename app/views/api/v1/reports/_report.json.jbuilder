json.(@report, :id, :title, :allow_title)

json.users report.users do |user|
	json.id user.id
end

json.templates report.templates do |template|
	
	json.id template.id
	json.name template.name
	json.sections template.sections
	json.columns template.columns
	
	json.fields template.fields do |field|
		json.id field.id
		json.name field.name
		json.section_id field.section_id
		json.column_id field.column_id
		json.fieldtype field.fieldtype
		json.required field.required
		json.disabled field.disabled

		json.options field.options do |option|
			json.name option.name
		end
	end
end

json.values report.values do |value|
	json.id value.id
	json.input value.input
	json.field_id value.field_id
end