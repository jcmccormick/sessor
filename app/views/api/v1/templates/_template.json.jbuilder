json.(template, :id, :name, :updated_at, :draft, :sections, :private_world, :private_group, :group_id, :group_edit, :group_editors, :gs_url)

json.fields template.fields do |field|
    
    json.id field.id
    json.fieldtype field.fieldtype
    json.o field.o
    
end