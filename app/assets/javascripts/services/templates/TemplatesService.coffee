services = angular.module('services')
services.service('TemplatesService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($interval, $location, $q, $rootScope, ClassFactory, Flash)->

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
				# 			fields: tempCopy.fields
				# 		})
				# 		template.drafts.length > 5 && template.drafts.pop()
				# 	for draft in template.drafts
				# 		draft.recent = moment(draft.time).fromNow()
				# 	$location.path().search(template.id+'/edit') == -1 && clearInterval(collectDrafts)
				# ), 10000


	templates = []
	
	validateTemplate = (template)->
		deferred = $q.defer()

		# prepare a copy of the template for sending to the DB
		# sending only the necessary data back
		tempCopy = new ClassFactory()
		angular.copy {
			id: template.id
			name: template.name
			draft: template.draft
			private_group: template.private_group
			private_world: template.private_world
			group_edit: template.group_edit
			group_editors: template.group_editors
			sections: (template.sections && template.sections.length && template.sections) || undefined
			fields_attributes: (template.fields && template.fields.length && template.fields) || undefined
			errors: ''
		}, tempCopy

		if tempCopy.fields_attributes
			# fields without a section ID are removed, as they will
			# be removed when saving tempCopy; the following makes sure
			# any deleted fields will be removed from the client's 
			# template model
			i = template.fields.length
			while i--
				template.fields[i].o == undefined && template.fields.splice(i, 1)

			if !template.deletingSection
				# validate field name or placeholder presence
				$.grep(tempCopy.fields_attributes, (field)->
					!field.o.name && !field.o.placeholder && !field.o.default_value
				).length && tempCopy.errors += '<p>Fields must have a name, placeholder, or default value.</p><p>Label and text elements must have a label or text.</p>'

		# validate name
		!tempCopy.name && template.name = 'Untitled'
		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(tempCopy.name) && tempCopy.errors += '<p>Template names must begin with a letter and only contain letters and numbers.</p>'

		template.deletingSection = false
		deferred.resolve(tempCopy)
		return deferred.promise

	newFieldOrdering = (template, section_id, column_id)->
		count = $.grep template.fields, (tempField)->
			section_id == tempField.o.section_id && column_id == tempField.o.column_id
		return count.length+1

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true

		returnTemplates: ->
			templates

		returnTemplate: (id)->
			deferred = $q.defer()
			for temp in templates
				if parseInt(temp.id, 10) == parseInt(id, 10)
					$.extend this, temp
					deferred.resolve(this)

			if parseInt(id, 10) != parseInt(this.id, 10)
				template = this
				ClassFactory.get({class: 'templates', id: id}, (res)->
					$.extend template, res
					templates.push template
					deferred.resolve(template)
				)

			return deferred.promise

		# save/update template
		saveTemplate: (temporary, form, template)->
			# Auto-save
			!timedSave && timedSave = $interval (->
				template.id && !form.$pristine && template.saveTemplate(true, form, template)
			), 30000


			!dereg && dereg = $rootScope.$on('$locationChangeSuccess', ()->
				$interval.cancel(timedSave)
				dereg()
			)

			# Validate and save
			validateTemplate(template).then((res)->
				if !!res.errors
					Flash.create('danger', res.errors, 'customAlert')
					return
				
				!res.id && res.$save({class: 'templates'}, (res)->
					templates.push res
					$location.path("/templates/#{res.id}/edit")
				)

				if res.id
					!form.$pristine && res.$update({class: 'templates', id: res.id})
					!temporary && $location.path("/templates/#{res.id}")
				
				$rootScope.$broadcast('cleartemplates')
				form && form.$setPristine()
			)
			return

		# delete template
		deleteTemplate: (template)->
			templates.splice(template, 1)
			template.$delete({class: 'templates', id: template.id}, (res)->
				$rootScope.$broadcast('cleartemplates')
				$location.path("/templates")
			)
			return

		# add section
		addSection: ()->
			this.sections.push({
				i: this.sections.length+1
				n: (this.newSectionName || '')
				c: 1
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
				field.o.section_id == section.i && field.o.column_id == section.c && prevent = true
			if prevent 
				Flash.create('danger', '<p>Please move any fields out of the last column.</p>', 'customAlert')
			else
				section.c--
			return

		# delete section
		deleteSection: (section_id, form)->
			this.sO = undefined

			this.sections.splice section_id-1, 1
			for section in this.sections
				section.i > section_id && section.i--

			for field in this.fields
				(field.o.section_id > section_id && field.o.section_id--) || field.o.section_id == section_id && field.o = undefined

			this.deletingSection = true
			this.saveTemplate(true, form, this)
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
			field.fieldtype = type.name
			field.o = {}
			field.o.column_order = newFieldOrdering(this, section_id, column_id)
			field.o.section_id = section_id
			field.o.column_id = column_id
			this.sO = field
			this.fields.push field
			field.o.name = this.newFieldName
			field.o.placeholder = this.newFieldPlaceholder
			field.o.default_value = this.newFieldDefaultValue
			!this.newFieldName && !this.newFieldPlaceholder && !this.newFieldDefaultValue && field.o.name = 'Untitled '+type.value
			field.o.glyphicon = type.glyphicon
			field.template_id = this.id
			field.$save({class: 'fields'}, (res)->
				$rootScope.$broadcast('cleartemplates')
			)
			this.newFieldName = undefined
			this.newFieldPlaceholder = undefined
			this.newFieldDefaultValue = undefined
			return

		# delete field
		deleteField: (field)->
			this.sO = undefined
			this.fields.splice field, 1
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id})
			for tempField in this.fields
				tempField.o.section_id == field.o.section_id && tempField.o.column_id == field.o.column_id && tempField.o.column_order > field.o.column_order && tempField.o.column_order--
			return

		# change a field's section_id
		changeFieldSection: (field, prev_section)->
			prev_column = field.o.column_id
			prev_column_order = field.o.column_order
			field.o.column_id = 1
			field.o.column_order = 1
			for tempField in this.fields
				tempField.o.section_id == prev_section*1 && tempField.o.column_id == prev_column && tempField.o.column_order >= prev_column_order && tempField.o.column_order--
				tempField.id != field.id && tempField.o.section_id == field.o.section_id && tempField.o.column_id == field.o.column_id && tempField.o.column_order++
			return

		# change a field's column_id
		changeFieldColumn: (field, column_id)->
			orig_col = field.o.column_id
			orig_col_ord = field.o.column_order
			field.o.column_id = column_id
			field.o.column_order = 1

			sect = $.grep this.sections, (section)->
				section.i == field.o.section_id
			index = this.sections.indexOf(sect[0])

			sect_fields = $.grep this.fields, (tempField)->
				tempField.o.section_id == field.o.section_id

			if column_id > 0 && column_id <= this.sections[index].c
				orig_col != column_id && for tempField in sect_fields
					tempField.o.column_id == orig_col && tempField.o.column_order > orig_col_ord && tempField.o.column_order--
					tempField.o.column_id == column_id && tempField.id != field.id && tempField.o.column_order++
			else
				field.o.column_id = orig_col
				field.o.column_order = orig_col_ord
			return

		# reorder field up or down in a column
		moveField: (field, direction)->

			field_switch = $.grep this.fields, (tempField)->
				if field.o.column_id == tempField.o.column_id && field.o.section_id == tempField.o.section_id
					if direction == 'up'
						field.o.column_order-1 == tempField.o.column_order
					else
						field.o.column_order+1 == tempField.o.column_order

			field_switch = field_switch[0]
			
			if !field_switch then return

			target = field_switch.o.column_order
			field_switch.o.column_order = field.o.column_order
			field.o.column_order = target
			return

		# add field option
		addOption: (field) ->
			!field.o.options && field.o.options = []
			field.o.options.push 'Option '+(field.o.options.length + 1)
			return

		# delete field option
		deleteOption: (field, option)->
			field.o.options.splice option, 1
			return

		# Helper functions

		# limit fields to a maximum value
		activeFields: ->
			counter = $.grep this.fields, (field)->
				field.o
			return counter.length || 0

		# set draft
		assimilate: (draft)->
			this.sO = undefined
			$.extend this, draft
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