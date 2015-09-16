services = angular.module('services')
services.service('TemplatesService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
	
	validateTemplate = (template)->
		deferred = $q.defer()
		errors = ''

		template.fields_attributes = template.fields
		template.fields && template.fields_attributes.forEach((field)->
			field.options_attributes = field.options
			field.values_attributes = field.values
		)

		if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test template.name
			errors += '<p>Template names must begin with a letter and only contain letters and numbers.</p>'
		else if !template.name
			template.name = 'Untitled'

		deferred.resolve(errors)
		return deferred.promise

	newFieldOrdering = (template, section_id, column_id)->
		count = $.grep template.fields, (i)->
			if section_id == i.section_id
				column_id == i.column_id
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
		setSelectedOptions: (optionSet, template)->
			if template.editing
				template.selectedOptions = optionSet

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
			template.hideName = true
			template.editing = true
			template.newFieldSection = 0
			template.countColumns = this.countColumns
			template.setFieldType = this.setFieldType
			template.setSelectedOptions = this.setSelectedOptions
			template.saveTemplate = this.saveTemplate
			template.deleteTemplate = this.deleteTemplate
			template.addSection = this.addSection
			template.addSectionColumn = this.addSectionColumn
			template.deleteSectionColumn = this.deleteSectionColumn
			template.deleteSection = this.deleteSection
			template.moveSection = this.moveSection
			template.addField = this.addField
			template.deleteField = this.deleteField
			template.moveField = this.moveField
			template.changeFieldColumn = this.changeFieldColumn
			template.addOption = this.addOption
			template.deleteOption = this.deleteOption
			template.moveSectionUp = this.moveSectionUp
			template.moveSectionDown = this.moveSectionDown
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
		addSection: (name, columns, tempForm, template)->
			tempForm.$dirty = true
			if !template.sections
				template.sections = []
				template.columns = []
			template.sections.push name
			template.columns.push columns
			template.saveTemplate(true, tempForm, template)
			template.newSectionName = ''
			template.selectedOptions = template.sections.indexOf(name)
			return

		# add section column
		addSectionColumn: (template, section_id, tempForm)->
			tempForm.$dirty = true
			template.columns[section_id]++
			template.saveTemplate(true, tempForm, template)
			return

		# delete section column
		deleteSectionColumn: (template, section_id, tempForm)->
			for field in template.fields
				if field.section_id == section_id+1 && field.column_id == template.columns[section_id]
					prevent = true

			if prevent
				Flash.create('danger', '<p>Please move any fields out of the last column.</p>', 'customAlert')
			else
				tempForm.$dirty = true
				template.columns[section_id]--
				template.saveTemplate(true, tempForm, template)
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

		# add field
		addField: (template, section_id, column_id, type, name, tempForm)->
			field = new ClassFactory()
			field.template_id = template.id
			field.section_id = section_id
			field.column_id = column_id
			field.column_order = newFieldOrdering(template, section_id, column_id)
			field.fieldtype = type.name
			field.glyphicon = type.glyphicon
			field.name = name
			field.$save({class: 'fields'}, (res)->
				res.values = []
				value = new ClassFactory()
				value.field_id = res.id
				value.$save({class: 'values'}, (val)->
					res.values.push val
					template.fields.push res
					tempForm.$setPristine()
					Flash.create('success', '<p>'+field.name+' successfully added to '+template.name+': '+template.sections[section_id-1]+'.</p>', 'customAlert')
					template.selectedOptions = res
				)
			)
			template.newFieldName = undefined
			template.newFieldAdd = undefined
			return

		# delete field
		deleteField: (template, field, tempForm)->
			tempForm.$dirty = true
			if template.selectedOptions.id == field.id then template.selectedOptions = undefined
			index = template.fields.indexOf(field)
			template.fields.splice index, 1
			for fie in template.fields
				if field.section_id == fie.section_id && field.column_id == fie.column_id && field.column_order < fie.column_order
					fie.column_order--
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id}, (res)->
				template.saveTemplate(true, tempForm, template)
			)
			return

		# change a field's column_id
		changeFieldColumn: (template, field, column_id)->
			if field.column_id != column_id
				for tempField in template.fields
					if field.section_id == tempField.section_id
						if field.column_id == tempField.column_id && field.column_order < tempField.column_order
							tempField.column_order--
						else if column_id == tempField.column_id
							tempField.column_order++

				field.column_id = column_id
				field.column_order = 1

			return

		# reorder field up or down
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
			if !field.options then field.options = new Array
			option = new ClassFactory()
			option.name = ''
			option.field_id = field.id
			field.options.push option
			option.$save({class: 'options'})
			return

		# delete field option
		deleteOption: (field, option)->
			index = field.options.indexOf(option)
			field.options.splice index, 1
			$.extend option, new ClassFactory()
			option.$delete({class: 'options', id: option.id})
			return

		supportedFields: [
			'labelntext'
			'textfield'
			'textarea'
			'integer'
			'date'
			'time'
			'checkbox'
			'radio'
			'dropdown'
			'email'
			# 'masked'
		]

		fields: [
			{
				name: 'labelntext'
				value: 'Label and Text'
				glyphicon: 'glyphicon-text-size'
			}
			{
				name: 'textfield'
				value: 'Text Line'
				glyphicon: 'glyphicon-font'
			}
			{
				name: 'textarea'
				value: 'Text Area'
				glyphicon: 'glyphicon-comment'
			}
			{
				name: 'email'
				value: 'E-mail'
				glyphicon: 'glyphicon-envelope'
			}
			{
				name: 'integer'
				value: 'Integer'
				glyphicon: 'glyphicon-th'
			}
			{
				name: 'date'
				value: 'Date'
				glyphicon: 'glyphicon-calendar'
			}
			{
				name: 'time'
				value: 'Time'
				glyphicon: 'glyphicon-time'
			}
			{
				name: 'checkbox'
				value: 'Checkbox'
				glyphicon: 'glyphicon-check'
			}
			{
				name: 'radio'
				value: 'Radio'
				glyphicon: 'glyphicon-record'
			}
			{
				name: 'dropdown'
				value: 'Dropdown'
				glyphicon: 'glyphicon-list'
			}
			# {
			#   name: 'masked'
			#   value: 'Masked'
			#   glyphicon: 'glyphicon-lock'
			# }
		]
	}
])