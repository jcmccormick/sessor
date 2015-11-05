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
		json.fieldtype field.fieldtype
		json.o field.o

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