controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$rootScope', '$scope', '$routeParams', '$location', 'ClassFactory', 'Flash', 'TemplateService',
($rootScope, $scope, $routeParams, $location, ClassFactory, Flash, TemplateService)->

	window.TEMPLATE_SCOPE = $scope

	if $routeParams.templateId
		ClassFactory.get({class: 'templates', id: $routeParams.templateId}, (res)->
			$scope.template = res
			$scope.template.hideName = false
			$scope.template.editing = true
			$scope.template.fieldTypes = TemplateService.fields

			# These functions are defined once the template resolves
			# in order to use the them in template-form-directive

			# set the field type used when adding a field
			$scope.template.setFieldType = (type)->
				$scope.newFieldType = type
				return

			# return an array for column repeating
			$scope.template.countColumns = (columns)->
				return new Array columns

			# save/update template
			$scope.template.saveTemplate = (temp, template)->
				if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.template.name
					Flash.create('danger', '<p>Page names must begin with a letter and only contain letters and numbers.</p>', 'customAlert')
				else
					$rootScope.$broadcast('cleartemplates')
					tempCopy = new ClassFactory()
					$.extend tempCopy, $scope.template
					tempCopy.fields_attributes = tempCopy.fields
					tempCopy.fields && tempCopy.fields_attributes.forEach((field)->
						field.options_attributes = field.options
						field.values_attributes = field.values
					)
					tempCopy.$update({class: 'templates', id: $scope.template.id}, (res)->
						Flash.create('success', '<p>Page updated!</p>', 'customAlert')
						if !temp
							$location.path("/templates/#{res.id}")
					)

			# delete template
			$scope.template.deleteTemplate = ->
				$rootScope.$broadcast('cleartemplates')
				$scope.template.$delete({class: 'templates', id: $scope.template.id}, (res)->
					$location.path("/templates")
				)
				return

			# add section
			$scope.template.addNewSection = (name, column_id)->
				if !$scope.template.sections
					$scope.template.sections = []
					$scope.template.columns = []
				$scope.template.sections.push name
				$scope.template.columns.push column_id
				$scope.newSectionName = ""
				return

			# delete section
			$scope.template.deleteSection = (template, index) ->
				template.dfids = []
				tempFields = []

				for field in template.fields
					if field.section_id == index+1
						template.dfids.push field.id
					else if field.section_id > index+1
						field.section_id--

				template.fields = $.grep template.fields, (i) ->
					$.inArray(i.id, template.dfids) == -1

				template.columns.splice index, 1
				template.sections.splice index, 1

				template.saveTemplate(true, template)
				template.dfids = undefined
				return

			# add field
			$scope.template.addNewField = (template, section_id, column_id, type, name)->
				field = new ClassFactory()
				field.name = name
				field.fieldtype = type.name
				field.required = undefined
				field.disabled = undefined
				field.glyphicon = type.glyphicon
				field.section_id = section_id
				field.column_id = column_id
				field.template_id = template.id
				field.$save({class: 'fields'}, (res)->
					field.values = []
					value = new ClassFactory()
					value.field_id = res.id
					value.$save({class: 'values'}, (val)->
						field.values.push val
						template.fields.push res
					)
				)
				$scope.newFieldName = ''
				$scope.newFieldName.$dirty = false
				return

			# delete field
			$scope.template.deleteField = (template, field) ->
				index = template.fields.indexOf(field)
				template.fields.splice index, 1
				template.selectedOptions = undefined
				$.extend field, new ClassFactory()
				field.$delete({class: 'fields', id: field.id})
				return

			# add field option
			$scope.template.addOption = (field) ->
				if !field.options then field.options = new Array
				option = new ClassFactory()
				option.name = ''
				option.field_id = field.id
				field.options.push option
				option.$save({class: 'options'})
				return

			# delete field option
			$scope.template.deleteOption = (field, option) ->
				index = field.options.indexOf(option)
				field.options.splice index, 1
				$.extend option, new ClassFactory()
				option.$delete({class: 'options', id: option.id})
				return

			# Reordering
			$scope.template.moveSectionUp = (template, index)->
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

			$scope.template.moveSectionDown = (template, index)->
				
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

		)
	else
		$scope.template = new ClassFactory()
		$scope.template.creator_uid = $scope.$parent.user
		$scope.template.hideName = false
		$scope.template.saveTemplate = ->
			if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.template.name
				Flash.create('danger', '<p>Title must begin with a letter and only contain letters and numbers.</p>', 'customAlert')
			else
				$scope.template.$save({class: 'templates'}, (res)->	$location.path('templates/'+res.id+'/edit')	)

])