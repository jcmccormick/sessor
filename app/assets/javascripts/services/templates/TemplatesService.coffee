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
			$.extend this, {sections: draft.sections,columns: draft.columns,fields: draft.fields}

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
			this.form = form
			this.editing = true
			this.drafts = []

			template = new ClassFactory()
			$.extend template, this

			ClassFactory.get({class: 'templates', id: id}, (res)->
				$.extend template, res

				#collect drafts
				form && collectDrafts = $interval (->
					if form.$dirty
						tempCopy = angular.copy template
						template.drafts.length > 4 && template.drafts.pop()
						template.drafts.unshift({
							time: moment()
							recent: moment(this.time).fromNow()
							sections: tempCopy.sections
							columns: tempCopy.columns
							fields: tempCopy.fields
						})
					for draft in template.drafts
						draft.recent = moment(draft.time).fromNow()
				), 30000

				# Auto-save
				form && innerSave = window.setInterval (->
					form.$dirty && template.saveTemplate(true) && console.log 'saving template #'+template.id
					$location.path().search(template.id+'/edit') == -1 && clearInterval(innerSave)
				), 60000

				deferred.resolve(template)
			)

			return deferred.promise

		# save/update template
		saveTemplate: (temporary)->
			this.form.$dirty && validateTemplate(this).then((res)->
				tempCopy = angular.copy res
				if !!tempCopy.errors 
					Flash.create('danger', tempCopy.errors, 'customAlert')
					return

				if !tempCopy.id
					tempCopy.$save({class: 'templates'}, (res)->
						$location.path("/templates/#{res.id}/edit")
					)
				else
					tempCopy.$update({class: 'templates', id: tempCopy.id}, (res)->
						$rootScope.$broadcast('cleartemplates')
						res.form.$setPristine()
						!temporary && $location.path("/templates/#{this.id}")
					)
			)
			!this.form.$dirty && !temporary && $location.path("/templates/#{this.id}")

		# delete template
		deleteTemplate: (template)->
			template.$delete({class: 'templates', id: template.id}, (res)->
				$rootScope.$broadcast('cleartemplates')
				$location.path("/templates")
			)
			return

		# add section
		addSection: ()->
			this.sections.push(this.newSectionName || '')
			this.columns.push 1
			this.newSectionName = undefined
			this.form.$dirty = true
			return

		# add section column
		addSectionColumn: (section_id)->
			this.columns[section_id]++
			this.form.$dirty = true
			return

		# delete section column
		deleteSectionColumn: (section_id)->
			for field in this.fields
				field.section_id == section_id+1 && field.column_id == this.columns[section_id] && prevent = true
			if prevent 
				Flash.create('danger', '<p>Please move any fields out of the last column.</p>', 'customAlert')
			else
				this.columns[section_id]--
				this.form.$dirty = true
			return

		# delete section
		deleteSection: (index)->
			this.selectedOptions = undefined

			for field in this.fields
				field.section_id == index+1 && field.section_id = ""
				field.section_id > index+1 && field.section_id--
			this.columns.splice index, 1
			this.sections.splice index, 1

			this.form.$dirty = true
			return

		# reorder section up or down
		moveSection: (index, direction)->
			directed_index = if direction == 'up' then index-1 else index+1

			if directed_index < this.sections.length && directed_index >= 0
				target = this.sections[directed_index]
				this.sections[directed_index] = this.sections[index]
				this.sections[index] = target

				target = this.columns[directed_index]
				this.columns[directed_index] = this.columns[index]
				this.columns[index] = target

				for field in this.fields
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
				this.selectedOptions = directed_index
			else
				this.selectedOptions = index
			this.form.$dirty = true
			return

		# add field
		addField: (section_id, column_id, type)->
			field = new ClassFactory()
			this.fields.push field
			this.selectedOptions = field
			field.name = this.newFieldName
			field.placeholder = this.newFieldPlaceholder
			!this.newFieldName && !this.newFieldPlaceholder && field.name = 'Untitled '+type.value
			field.template_id = this.id
			field.column_order = newFieldOrdering(this, section_id, column_id)
			field.column_id = column_id
			field.section_id = section_id
			field.fieldtype = type.name
			field.glyphicon = type.glyphicon
			field.$save({class: 'fields'}, (res)->
				$rootScope.$broadcast('cleartemplates')
			)
			this.newFieldName = undefined
			this.newFieldPlaceholder = undefined
			return

		# delete field
		deleteField: (field)->
			this.selectedOptions = undefined
			index = this.fields.indexOf(field)
			this.fields.splice index, 1
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id})
			for tempField in this.fields
				tempField.section_id == field.section_id && tempField.column_id == field.column_id && tempField.column_order > field.column_order && tempField.column_order--
			this.form.$dirty = true
			return

		# change a field's section_id
		changeFieldSection: (field, prev_section)->
			prev_column = field.column_id
			prev_column_order = field.column_order
			field.column_id = 1
			field.column_order = 1
			for tempField in this.fields
				tempField.section_id == prev_section*1 && tempField.column_id == prev_column && tempField.column_order >= prev_column_order && tempField.column_order--
				tempField.id != field.id && tempField.section_id == field.section_id && tempField.column_id == field.column_id && tempField.column_order++
			this.form.$dirty = true
			return

		# change a field's column_id
		changeFieldColumn: (field, column_id)->
			if column_id > 0 && column_id <= this.columns[field.section_id-1]
				field.column_id != column_id && for tempField in this.fields
					if tempField.section_id == field.section_id
						tempField.column_id == field.column_id && tempField.column_order > field.column_order && tempField.column_order--
						tempField.column_id == column_id && tempField.column_order++
				field.column_id = column_id
				field.column_order = 1
			this.form.$dirty = true
			return

		# reorder field up or down in a column
		moveField: (field, direction)->

			field_switch = $.grep this.fields, (i)->
				if field.column_id == i.column_id && field.section_id == i.section_id
					if direction == 'up'
						field.column_order-1 == i.column_order
					else
						field.column_order+1 == i.column_order

			field_switch = field_switch[0]
			
			if !field_switch then return

			target = field_switch.column_order
			field_switch.column_order = field.column_order
			field.column_order = target

			this.form.$dirty = true
			return

		# add field option
		addOption: (field) ->
			field.options.push 'Option '+(field.options.length + 1)
			this.form.$dirty = true
			return

		# delete field option
		deleteOption: (field, option)->
			index = field.options.indexOf(option)
			field.options.splice index, 1
			this.form.$dirty = true
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