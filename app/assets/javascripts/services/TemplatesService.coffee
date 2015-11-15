services = angular.module('services')
services.service('TemplatesService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($interval, $location, $q, $rootScope, ClassFactory, Flash)->

	templates = []
	
	validateTemplate = (template)->
		deferred = $q.defer()

		# prepare a copy of the template for sending to the DB
		# sending only the necessary data back
		tempCopy = new ClassFactory()
		angular.copy template, tempCopy

		if tempCopy.fields && tempCopy.fields_attributes = tempCopy.fields
			# fields marked destroy are removed, as they will
			# be removed when saving tempCopy; the following makes sure
			# any deleted fields will be removed from the client's 
			# template model
			i = template.fields.length
			while i--
				template.fields[i].o == "destroy" && template.fields.splice(i, 1)

			console.log template.deletingSection

			if !template.deletingSection && !template.settingDraft
				# validate field name or placeholder presence
				$.grep(tempCopy.fields_attributes, (field)->
					!field.o.name && !field.o.placeholder && !field.o.default_value
				).length && tempCopy.errors += '<p>Fields must have a name, placeholder, or default value.</p><p>Label and text elements must have a label or text.</p>'

		# validate name
		!tempCopy.name && template.name = 'Untitled'
		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(tempCopy.name) && tempCopy.errors += '<p>Template names must begin with a letter and only contain letters and numbers.</p>'

		template.deletingSection = false
		template.settingDraft = false
		deferred.resolve(tempCopy)
		return deferred.promise

	newFieldOrdering = (template, section_id, column_id)->
		!template.fields && template.fields = []
		return ($.grep template.fields, (tempField)-> section_id == tempField.o.section_id && column_id == tempField.o.column_id).length+1

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true
		creating: ->
			return if $location.path().search('/new') == -1 then false else true

		listTemplates: ->
			deferred = $q.defer()
			if templates.length
				return templates
			else
				ClassFactory.query({class: 'templates'}, (res)->
					$.extend templates, res
					deferred.resolve(templates)
				)
			return deferred.promise

		queryTemplate: (id)->
			deferred = $q.defer()
			exists = $.map(templates, (x)-> x.id).indexOf(id)
			if exists >= 0 && templates[exists].loadedFromDB
				deferred.resolve(templates[exists])
			else if id
				ClassFactory.get({class: 'templates', id: id}, (res)->
					res.loadedFromDB = true
					if exists >= 0
						$.extend templates[exists], res
					else
						addex = templates.push(res)
					deferred.resolve(templates[exists || addex-1])
				)
			return deferred.promise

		getTemplates: ->
			return templates

		getTemplate: (id)->
			if !id
				delete this.id
				this.name = ''
				this.fields = []
				this.sections = []
				this.e = false
			template = ($.grep templates, (temp)-> temp.id == id)[0]
			template = $.extend this, template
			return template

		# save/update template
		saveTemplate: (temporary, form)->
			# Auto-save
			!timedSave && timedSave = $interval (->
				this.id && !form.$pristine && this.saveTemplate(true, form)
			), 30000

			!dereg && dereg = $rootScope.$on('$locationChangeSuccess', ()->
				$interval.cancel(timedSave)
				dereg()
			)

			(this.deletingSection || this.settingDraft) && form.$pristine = false

			# Validate and save
			validateTemplate(this).then((template)->
				if !!template.errors
					Flash.create('danger', template.errors, 'customAlert')
					return
				
				!template.id && template.$save({class: 'templates'}, (res)->
					templates.push res
					$location.path("/templates/#{res.id}/edit")
					return
				)

				if template.id
					!form.$pristine && template.$update({class: 'templates', id: template.id}, (res)->
						!temporary && $location.path("/templates/#{res.id}")
						form.$setPristine()
						return
					)
					form.$pristine && !temporary && $location.path("/templates/#{template.id}")
					return
			)
			return

		# delete template
		deleteTemplate: (form)->
			$.extend this, new ClassFactory()
			this.$delete({class: 'templates', id: this.id}, ((res)->
				index = templates.indexOf ($.grep templates, (template)-> res.id == template.id)[0]
				templates.splice(index, 1)
				form.$setPristine()
				$location.path("/templates")
			), (err)->
				Flash.create('danger', '<p>'+err.data.errors+'</p>', 'customAlert')
			)
			return

		# add section
		addSection: ()->
			!this.sections && this.sections = []
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

			for field in this.fields
				(field.o.section_id > section_id && field.o.section_id--) || field.o.section_id == section_id && field.o = 'destroy'

			this.sections.splice section_id-1, 1
			for section in this.sections
				section.i > section_id && section.i--

			this.deletingSection = true
			this.saveTemplate(true, form)
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
			f = ($.grep this.fields, (f)-> f.id == field.id)[0]
			index = this.fields.indexOf(f)
			this.fields.splice index, 1
			$.extend field, new ClassFactory()
			field.$delete({class: 'fields', id: field.id})
			for tempField in this.fields
				tempField.o.section_id == f.o.section_id && tempField.o.column_id == f.o.column_id && tempField.o.column_order > f.o.column_order && tempField.o.column_order--
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