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

	{
		# return an array for column repeating
		countColumns: (columns)->
			return new Array columns

		# set the field type used when adding a field
		setFieldType: (type, template)->
			template.newFieldType = type
			return

		setSelectedOptions: (optionSet, template)->
			if template.editing
				template.selectedOptions = optionSet

		newTemplate: ->
			template = new ClassFactory()
			template.hideName = false
			template.creator_uid = $rootScope.user
			template.saveTemplate = this.saveTemplate
			return template

		getTemplate: (id)->
			deferred = $q.defer()
			template = new ClassFactory()
			template.hideName = false
			template.editing = true
			template.countColumns = this.countColumns
			template.setFieldType = this.setFieldType
			template.setSelectedOptions = this.setSelectedOptions
			template.saveTemplate = this.saveTemplate
			template.deleteTemplate = this.deleteTemplate
			template.addNewSection = this.addNewSection
			template.deleteSection = this.deleteSection
			template.addNewField = this.addNewField
			template.deleteField = this.deleteField
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
						Flash.create('success', '<p>Template saved!</p>', 'customAlert')
					)
				else
					tempCopy.$update({class: 'templates', id: tempCopy.id}, (res)->
						$rootScope.$broadcast('cleartemplates')
						Flash.create('success', '<p>Template updated!</p>', 'customAlert')
						if tempForm != 'delsec' then tempForm.$setPristine()
						if !temp then $location.path("/templates/#{res.id}")
						deferred.resolve('updated')
					)
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
		addNewSection: (name, columns, tempForm, template)->
			if !template.sections
				template.sections = []
				template.columns = []
			template.sections.push name
			template.columns.push columns

			tempForm.$dirty = true
			template.saveTemplate(true, tempForm, template)
			template.newSectionName = ''
			return

		# delete section
		deleteSection: (template, index) ->
			template.dfids = []

			for field in template.fields
				if field.section_id == index+1
					template.dfids.push field.id
				else if field.section_id > index+1
					field.section_id--
			template.fields = $.grep template.fields, (i) ->
				$.inArray(i.id, template.dfids) == -1
			template.columns.splice index, 1
			template.sections.splice index, 1

			template.saveTemplate(true, 'delsec', template).then((res)-> 
				template.dfids = undefined
			)
			return

		# add field
		addNewField: (template, section_id, column_id, type, name)->
			field = new ClassFactory()
			field.template_id = template.id
			field.section_id = section_id
			field.column_id = column_id
			field.fieldtype = type.name
			field.glyphicon = type.glyphicon
			field.name = name
			field.$save({class: 'fields'}, (res)->
				field.values = []
				value = new ClassFactory()
				value.field_id = res.id
				value.$save({class: 'values'}, (val)->
					field.values.push val
					template.fields.push res
				)
			)
			template.newFieldName = ''
			return

		# delete field
		deleteField: (template, field) ->
			index = template.fields.indexOf(field)
			template.fields.splice index, 1
			template.selectedOptions = undefined
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id})
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
		deleteOption: (field, option) ->
			index = field.options.indexOf(option)
			field.options.splice index, 1
			$.extend option, new ClassFactory()
			option.$delete({class: 'options', id: option.id})
			return

		# Section Reordering
		moveSectionUp: (template, index)->
			tempSection = template.sections[index]
			template.sections[index] = template.sections[index-1]
			template.sections[index-1] = tempSection

			tempColumn = template.columns[index]
			template.columns[index] = template.columns[index-1]
			template.columns[index-1] = tempColumn
			
			for field in template.fields
				if field.section_id == index+1
					field.section_id--
				else if field.section_id == index
					field.section_id++
			return

		moveSectionDown: (template, index)->
			tempSection = template.sections[index]
			template.sections[index] = template.sections[index+1]
			template.sections[index+1] = tempSection

			tempColumn = template.columns[index]
			template.columns[index] = template.columns[index+1]
			template.columns[index+1] = tempColumn

			for field in template.fields
				if field.section_id == index+1
					field.section_id++
				else if field.section_id == index+2
					field.section_id--
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