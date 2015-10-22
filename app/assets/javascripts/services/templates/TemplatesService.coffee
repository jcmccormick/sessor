services = angular.module('services')
services.service('TemplatesService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
	
	validateTemplate = (template)->
		deferred = $q.defer()
		errors = ''

		template.fields_attributes = template.fields

		if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test template.name
			errors += '<p>Template names must begin with a letter and only contain letters and numbers.</p>'
		else if !template.name
			template.name = 'Untitled'

		deferred.resolve(errors)
		return deferred.promise

	newFieldOrdering = (template, section_id, column_id)->
		count = $.grep template.fields, (i)->
			section_id == i.section_id && column_id == i.column_id
		return count.length+1

	{
		# return an array for column repeating
		countColumns: (columns)->
			return new Array columns

		# set the field type used when adding a field
		setFieldType: (type, template)->
			template.newFieldType = type
			return

		# select a field's settings on template editing
		setSelectedOptions: (template, optionSet)->
			template.editing && template.selectedOptions = optionSet

		# add create new template object
		newTemplate: ->
			template = new ClassFactory()
			template.hideName = false
			template.saveTemplate = this.saveTemplate
			return template

		# retrieve template and grant services
		getTemplate: (id)->
			deferred = $q.defer()
			template = new ClassFactory()
			$.extend template, this
			template.hideName = true
			template.editing = true
			template.newFieldSection = 0
			ClassFactory.get({class: 'templates', id: id}, (res)->
				$.extend template, res
				deferred.resolve(template)
			)
			return deferred.promise

		# save/update template
		saveTemplate: (temp, tempForm, template)->
			deferred = $q.defer()
			validateTemplate(template).then((errors)->
				if !!errors 
					Flash.create('danger', errors, 'customAlert')
					deferred.resolve(errors)
					return

				tempCopy = new ClassFactory()
				$.extend tempCopy, template

				if !tempCopy.id
					tempCopy.sections = ['Section 1']
					tempCopy.columns = [1]
					tempCopy.$save({class: 'templates'}, (res)->
						$location.path("/templates/#{res.id}/edit")
						Flash.create('success', '<p>Page saved!</p>', 'customAlert')
					)
				else if tempForm.$dirty || typeof tempForm == 'string'
					tempCopy.$update({class: 'templates', id: tempCopy.id}, (res)->
						$rootScope.$broadcast('cleartemplates')
						Flash.create('success', '<p>Page updated!</p>', 'customAlert')
						if typeof tempForm == 'string'
							tempForm.$dirty = false
						else
							tempForm.$setPristine()
						if !temp then $location.path("/templates/#{res.id}")
						deferred.resolve('updated')
					)
				else
					Flash.create('info', '<p>Page unchanged.</p>', 'customAlert')
					if !temp
						deferred.resolve($location.path("/templates/#{template.id}"))
					else
						deferred.resolve()
			)
			return deferred.promise

		# delete template
		deleteTemplate: (template)->
			template.$delete({class: 'templates', id: template.id}, (res)->
				$rootScope.$broadcast('cleartemplates')
				$location.path("/templates")
			)
			return

		# add section
		addSection: (template, name, tempForm)->

			id = template.sections.length+1
			!name && name = 'Section ' + id
			template.sections.push name
			template.columns.push 1
			template.selectedOptions = template.sections.indexOf(name)
			tempForm.$dirty = true
			template.newSectionName = undefined
			return

		# add section column
		addSectionColumn: (template, section_id, tempForm)->
			tempForm.$dirty = true
			template.columns[section_id]++
			return

		# delete section column
		deleteSectionColumn: (template, section_id, tempForm)->
			for field in template.fields
				field.section_id == section_id+1 && field.column_id == template.columns[section_id] && prevent = true
			if prevent 
				Flash.create('danger', '<p>Please move any fields out of the last column.</p>', 'customAlert')
			else
				template.columns[section_id]--
				tempForm.$dirty = true
			return

		# delete section
		deleteSection: (template, index, tempForm)->
			if template.selectedOptions && !template.selectedOptions.fieldtype then template.selectedOptions = undefined
			tempForm.$dirty = true
			template.dfids = []

			for field in template.fields
				if field.section_id == index+1
					template.dfids.push field.id
				else if field.section_id > index+1
					field.section_id--
			template.fields = $.grep template.fields, (i)->
				$.inArray(i.id, template.dfids) == -1
			template.columns.splice index, 1
			template.sections.splice index, 1

			template.saveTemplate(true, tempForm, template).then((res)-> 
				template.dfids = undefined
			)
			return

		# reorder section up or down
		moveSection: (template, index, direction)->
			directed_index = if direction == 'up' then index-1 else index+1

			if template.sections[directed_index] != undefined
				target = template.sections[directed_index]
				template.sections[directed_index] = template.sections[index]
				template.sections[index] = target

				target = template.columns[directed_index]
				template.columns[directed_index] = template.columns[index]
				template.columns[index] = target

				for field in template.fields
					if direction == 'up'
						if field.section_id == index+1
							field.section_id--
						else if field.section_id == index
							field.section_id++
					if direction == 'down'
						if field.section_id == index+1
							field.section_id++
						else if field.section_id == index+2
							field.section_id--
				template.selectedOptions = directed_index
			else
				template.selectedOptions = index
			return

		# add field
		addField: (template, section_id, column_id, type, name, placeholder, tempForm)->
			field = new ClassFactory()
			template.fields.push field
			template.selectedOptions = field
			field.name = name
			field.placeholder = placeholder
			!name && !placeholder && field.name = 'Untitled '+type.value
			field.template_id = template.id
			field.column_order = newFieldOrdering(template, section_id, column_id)
			field.column_id = column_id
			field.section_id = section_id
			field.fieldtype = type.name
			field.glyphicon = type.glyphicon
			field.$save({class: 'fields'}, (res)->
				tempForm.$setPristine()
				Flash.create('success', '<p>'+field.name+' successfully added to '+template.name+': '+template.sections[section_id-1]+'.</p>', 'customAlert')
			)
			$rootScope.$broadcast('cleartemplates')
			template.newFieldName = undefined
			template.newFieldPlaceholder = undefined
			template.newFieldAdd = undefined
			return

		# delete field
		deleteField: (template, field, tempForm)->
			tempForm.$dirty = true
			template.selectedOptions.id == field.id && template.selectedOptions = undefined
			index = template.fields.indexOf(field)
			template.fields.splice index, 1
			for tempField in template.fields
				tempField.section_id == field.section_id && tempField.column_id == field.column_id && tempField.column_order > field.column_order && tempField.column_order--
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id}, (res)->
				template.saveTemplate(true, tempForm, template)
			)
			return

		# change a field's section_id
		changeFieldSection: (template, field, prev_section)->
			prev_column = field.column_id
			prev_column_order = field.column_order
			field.column_id = 1
			field.column_order = 1
			for tempField in template.fields
				tempField.section_id == prev_section*1 && tempField.column_id == prev_column && tempField.column_order >= prev_column_order && tempField.column_order--
				tempField.id != field.id && tempField.section_id == field.section_id && tempField.column_id == field.column_id && tempField.column_order++

			return

		# change a field's column_id
		changeFieldColumn: (template, field, column_id)->
			field.column_id != column_id && for tempField in template.fields
				if tempField.section_id == field.section_id
					tempField.column_id == field.column_id && tempField.column_order > field.column_order && tempField.column_order--
					tempField.column_id == column_id && tempField.column_order++
			field.column_id = column_id
			field.column_order = 1
			return

		# reorder field up or down in a column
		moveField: (template, field, direction)->

			field_switch = $.grep template.fields, (i)->
				if field.column_id == i.column_id && field.section_id == i.section_id
					if direction == 'up'
						field.column_order-1 == i.column_order
					else
						field.column_order+1 == i.column_order

			field_switch = field_switch[0]
			
			if !field_switch
				return
			else
				target = field_switch.column_order
				field_switch.column_order = field.column_order
				field.column_order = target

			return

		# add field option
		addOption: (field) ->
			number = field.options.length + 1
			field.options.push 'Option '+number
			return

		# delete field option
		deleteOption: (field, option, template, tempForm)->
			tempForm.$dirty = true
			index = field.options.indexOf(option)
			field.options.splice index, 1
			template.saveTemplate(true, tempForm, template)
			return

		supportedFields: [
			'labelntext'
			'textfield'
			'textarea'
			'email'
			'integer'
			'date'
			'time'
			'checkbox'
			'radio'
			'dropdown'
			# 'masked'
		]

		addFieldTypes: [
			{name:'labelntext',value:'Label and Text',glyphicon:'glyphicon-text-size'}
			{name:'textfield',value:'Text Line',glyphicon:'glyphicon-font'}
			{name:'textarea',value:'Text Area',glyphicon:'glyphicon-comment'}
			{name:'email',value:'E-mail',glyphicon:'glyphicon-envelope'}
			{name:'integer',value:'Integer',glyphicon:'glyphicon-th'}
			{name:'date',value:'Date',glyphicon:'glyphicon-calendar'}
			{name:'time',value:'Time',glyphicon:'glyphicon-time'}
			{name:'checkbox',value:'Checkbox',glyphicon:'glyphicon-check'}
			{name:'radio',value:'Radio',glyphicon:'glyphicon-record'}
			{name:'dropdown',value:'Dropdown',glyphicon:'glyphicon-list'}
		]
	}
])