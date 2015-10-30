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
		# limit template options on new
		newTemplate: ->
			template = new ClassFactory()
			template.saveTemplate = this.saveTemplate
			return template

		# retrieve template and extend services
		getTemplate: (id, form)->
			deferred = $q.defer()

			template = new ClassFactory()
			$.extend template, this

			id && ClassFactory.get({class: 'templates', id: id}, (res)->
				$.extend template, res

				# editing
				form && template.e = true
				form && template.poppedOut = false

				# collect drafts
				# form && collectDrafts = $interval (->
				# 	!template.drafts && template.drafts = []
				# 	if !form.$pristine
				# 		tempCopy = angular.copy template
				# 		console.log 'creating draft'
				# 		console.log tempCopy.time
				# 		!tempCopy.time && template.drafts.push({
				# 			time: moment()
				# 			sections: tempCopy.sections
				# 			columns: tempCopy.columns
				# 			fields: tempCopy.fields
				# 		})
				# 		template.drafts.length > 5 && template.drafts.pop()
				# 	for draft in template.drafts
				# 		draft.recent = moment(draft.time).fromNow()
				# 	$location.path().search(template.id+'/edit') == -1 && clearInterval(collectDrafts)
				# ), 10000

				# Auto-save
				form && timedSave = window.setInterval (->
					!form.$pristine && template.saveTemplate(true, form)
					$location.path().search(template.id+'/edit') == -1 && clearInterval(timedSave)
				), 30000

				deferred.resolve(template)
			)

			!id && deferred.resolve(template)

			return deferred.promise

		# save/update template
		saveTemplate: (temporary, form)->
			console.log 'saving'
			validateTemplate(this).then((res)->
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
						res.del_fields && res.del_fields = undefined
						form && form.$setPristine()
						!temporary && $location.path("/templates/#{res.id}")
					)
			)

		# delete template
		deleteTemplate: (template)->
			template.$delete({class: 'templates', id: template.id}, (res)->
				$rootScope.$broadcast('cleartemplates')
				$location.path("/templates")
			)
			return

		# add section
		addSection: ()->
			this.sections.push({
				i:this.sections.length+1
				n:(this.newSectionName || '')
				c:1
			})
			this.sO = this.sections[this.sections.length-1]
			this.newSectionName = undefined
			
			return

		# add section column
		addSectionColumn: (section)->
			section.c++
			
			return

		# delete section column
		deleteSectionColumn: (section)->
			for field in this.fields
				field.section_id == section.i && field.column_id == section.c && prevent = true
			if prevent 
				Flash.create('danger', '<p>Please move any fields out of the last column.</p>', 'customAlert')
			else
				section.c--
				
			return

		# delete section
		deleteSection: (section_id)->
			this.del_fields = $.grep this.fields, (field)->
				field.section_id == section_id
			sub_fields = $.grep this.fields, (field)->
				field.section_id > section_id

			for field in this.del_fields
				field.section_id = ''
			
			for field in sub_fields
				field.section_id--			

			this.sections.splice section_id-1, 1
			for section in this.sections
				section.i > section_id && section.i--

			this.sO = undefined
			
			this.saveTemplate(true)
			return

		# reorder section up or down
		moveSection: (index, new_index)->

			if this.sections[new_index]
				target = this.sections[new_index]
				this.sections[new_index] = this.sections[index]
				this.sections[index] = target
				this.sO = this.sections[new_index]

				
			return


		# add field
		addField: (section_id, column_id, type)->
			field = new ClassFactory()
			this.fields.push field
			this.sO = field
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
			this.sO = undefined
			index = this.fields.indexOf(field)
			this.fields.splice index, 1
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id})
			for tempField in this.fields
				tempField.section_id == field.section_id && tempField.column_id == field.column_id && tempField.column_order > field.column_order && tempField.column_order--
			
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
			
			return

		# change a field's column_id
		changeFieldColumn: (field, column_id)->
			orig_col = field.column_id
			orig_col_ord = field.column_order
			field.column_id = column_id
			field.column_order = 1

			sect = $.grep this.sections, (section)->
				section.i == field.section_id
			index = this.sections.indexOf(sect[0])

			if column_id > 0 && column_id <= this.sections[index].c
				orig_col != column_id && for tempField in this.fields
					if tempField.section_id == field.section_id
						tempField.column_id == orig_col && tempField.column_order > orig_col_ord && tempField.column_order--
						tempField.column_id == column_id && tempField.id != field.id && tempField.column_order++
			else
				field.column_id = orig_col
				field.column_order = orig_col_ord
				
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

			
			return

		# add field option
		addOption: (field) ->
			field.options.push 'Option '+(field.options.length + 1)
			
			return

		# delete field option
		deleteOption: (field, option)->
			index = field.options.indexOf(option)
			field.options.splice index, 1
			
			return

		# Helper functions

		# return an array for column repeating
		countColumns: (columns)->
			return new Array columns

		activeFields: ->
			counter = $.grep this.fields, (field)->
				field.section_id != ''
			counter.length || 0

		# set the field type used when adding a field
		setFieldType: (type, template)->
			template.newFieldType = type
			return

		# select a field's settings on template editing
		setSelectedOptions: (template, optionSet)->
			template.editing && template.sO = optionSet

		assimilate: (draft)->
			this.sO = undefined
			$.extend this, draft

		setFieldDepth: (column)->
			return this.columns.indexOf(column)==3 || this.columns.indexOf(column)==2 || this.columns.indexOf(column)==1

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
			{name:'labelntext',value:'Label & Text',glyphicon:'glyphicon-text-size'}
			{name:'textfield',value:'Text Line',glyphicon:'glyphicon-font'}
			{name:'textarea',value:'Text Area',glyphicon:'glyphicon-comment'}
			{name:'email',value:'E-mail',glyphicon:'glyphicon-envelope'}
			{name:'date',value:'Date',glyphicon:'glyphicon-calendar'}
			{name:'time',value:'Time',glyphicon:'glyphicon-time'}
			{name:'integer',value:'Integer',glyphicon:'glyphicon-th'}
			{name:'checkbox',value:'Checkbox',glyphicon:'glyphicon-check'}
			{name:'radio',value:'Radio',glyphicon:'glyphicon-record'}
			{name:'dropdown',value:'Dropdown',glyphicon:'glyphicon-list'}
		]

	}
])