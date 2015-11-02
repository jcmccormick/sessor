json.(@report, :id, :title, :allow_title, :template_order)

json.users @report.users do |user|
	json.id user.id
end

json.templates @report.templates do |template|
	
	json.id template.id
	json.name template.name
	json.sections template.sections
	
	json.fields template.fields do |field|
		json.id field.id
		json.section_id field.section_id
		json.column_id field.column_id
		json.column_order field.column_order
		json.fieldtype field.fieldtype
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

		json.value do
			if field.fieldtype != 'labelntext'
				@report.values.each do |value|
					if value.field_id == field.id
						json.id value.id
						json.input value.input
					end
				end
			end
			if field.fieldtype == 'labelntext'
				json.input field.default_value
			end
		end

	end
end