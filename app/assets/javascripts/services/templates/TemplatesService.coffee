services = angular.module('services')
services.service('TemplatesService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($interval, $location, $q, $rootScope, ClassFactory, Flash)->
	
	validateTemplate = (template)->
		deferred = $q.defer()
		template.errors = ''
		template.fields_attributes = template.fields
		!template.name && template.name = 'Untitled'
		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(template.name) && template.errors += '<p>Template names must begin with a letter and only contain letters and numbers.</p>'

		deferred.resolve(template)
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

		assimilate: (draft)->
			this.selectedOptions = undefined
			$.extend this, draft

		setFieldDepth: (column)->
			return this.columns.indexOf(column)==3 || this.columns.indexOf(column)==2 || this.columns.indexOf(column)==1

		# add create new template object
		newTemplate: ->
			template = new ClassFactory()
			template.saveTemplate = this.saveTemplate
			return template

		# retrieve template and extend services
		getTemplate: (id, form)->
			deferred = $q.defer()
			template = new ClassFactory()
			$.extend template, this
			template.editing = true
			template.drafts = []
			ClassFactory.get({class: 'templates', id: id}, (res)->
				$.extend template, res
				form && collectDrafts = $interval (->
					tempCopy = angular.copy template
					template.drafts.length > 5 && template.drafts.pop()
					form.$dirty && template.drafts.unshift({
						time: new Date()
						sections: tempCopy.sections
						columns: tempCopy.columns
						fields: tempCopy.fields
					})
				), 10000

				form && innerSave = window.setInterval (->
					form.$dirty && template.saveTemplate(true, form) && console.log 'saving template #'+template.id
					$location.path().search(template.id+'/edit') == -1 && clearInterval(innerSave)
				), 30000

				deferred.resolve(template)
			)

			return deferred.promise

		# save/update template
		saveTemplate: (temp, tempForm)->
			deferred = $q.defer()
			validateTemplate(this).then((res)->
				tempCopy = angular.copy res
				if !!tempCopy.errors 
					Flash.create('danger', tempCopy.errors, 'customAlert')
					deferred.resolve(tempCopy)
					return

				if !tempCopy.id
					tempCopy.sections = ['Section 1']
					tempCopy.columns = [1]
					tempCopy.$save({class: 'templates'}, (res)->
						$location.path("/templates/#{res.id}/edit")
					)
				else
					tempCopy.$update({class: 'templates', id: tempCopy.id}, (res)->
						$rootScope.$broadcast('cleartemplates')
						tempForm.$setPristine()
						!temp && $location.path("/templates/#{res.id}") && Flash.create('success', '<p>Page updated!</p>', 'customAlert')
						deferred.resolve(res)
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
		addSection: (template, name, tempForm)->
			newSec = template.sections.push(name) - 1
			template.columns.push 1
			template.selectedOptions = template.sections.indexOf(newSec)
			template.newSectionName = undefined
			tempForm.$dirty = true
			return

		# add section column
		addSectionColumn: (template, section_id, tempForm)->
			template.columns[section_id]++
			tempForm.$dirty = true
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

			tempForm.$dirty = true
			template.saveTemplate(true, tempForm).then((res)-> 
				template.dfids = undefined
			)
			return

		# reorder section up or down
		moveSection: (template, index, direction)->
			directed_index = if direction == 'up' then index-1 else index+1

			if template.sections[directed_index]?
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
				$rootScope.$broadcast('cleartemplates')
			)
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
				template.saveTemplate(true, tempForm)
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
			template.saveTemplate(true, tempForm)
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