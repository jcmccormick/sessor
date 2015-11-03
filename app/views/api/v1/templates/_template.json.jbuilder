json.(@template, :id, :name, :draft, :private_world, :private_group, :group_id, :group_edit, :group_editors, :sections)

json.fields template.fields do |field|
	
	json.id field.id
	json.fieldtype field.fieldtype
	json.o field.o
end