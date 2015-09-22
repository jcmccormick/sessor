json.(@report, :id, :title, :allow_title, :template_order)

json.users @report.users do |user|
	json.id user.id
end

json.templates @report.templates do |template|
	
	json.id template.id
	json.name template.name
	json.sections template.sections
	json.columns template.columns
	
	json.fields template.fields do |field|
		json.id field.id
		json.name field.name
		json.section_id field.section_id
		json.column_id field.column_id
		json.column_order field.column_order
		json.fieldtype field.fieldtype
		json.required field.required
		json.disabled field.disabled
		json.options field.options

		json.value do
			@report.values.each do |value|
				if value.field_id == field.id
					json.id value.id
					json.input value.input
				end
			end
		end

	end
end