controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$auth', '$rootScope', '$scope', '$resource', '$routeParams', '$location', 'ClassFactory', 'Flash', 'TemplateService'
($auth, $rootScope, $scope, $resource, $routeParams, $location, ClassFactory, Flash, TemplateService)->

	window.TEMPLATE_SCOPE = $scope

	if $routeParams.templateId
		ClassFactory.get({class: 'templates', id: $routeParams.templateId}, (res)->
			$scope.template = res
		)
	else
		$scope.template = new ClassFactory()
		$scope.template.creator_uid = $auth.user.uid

	$scope.sectionTypes = TemplateService.sections
	$scope.columnTypes = TemplateService.columns
	$scope.fieldTypes = TemplateService.fields
	$scope.previewTemplate = {}

	# separate preview from actual template
	$scope.previewUpdate = ->
		$scope.showModal = true
		angular.copy $scope.template, $scope.previewTemplate
		return

	# return an array for column repeating
	$scope.countColumns = (columns)->
		return new Array columns

	# save/update template
	$scope.saveTemplate = (temp)->
		if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.template.name
			Flash.create('error', 'Title must begin with a letter and only contain letters and numbers.')
		else
			$rootScope.$broadcast('cleartemplates')
			if !$scope.template.id
				$scope.template.$save({class: 'templates'}, (res)->
					$location.path('templates/'+res.id+'/edit')
				)
			else
				tempCopy = new ClassFactory()
				$.extend tempCopy, $scope.template
				tempCopy.fields_attributes = tempCopy.fields
				tempCopy.fields && tempCopy.fields_attributes.forEach((field)->
					field.options_attributes = field.options
					field.values_attributes = field.values
				)
				tempCopy.$update({class: 'templates', id: $scope.template.id}, (res)->
					if !temp
						$location.path("/templates/#{res.id}")
				)

	# delete template
	$scope.deleteTemplate = ->
		$rootScope.$broadcast('cleartemplates')
		$scope.template.$delete({class: 'templates', id: $scope.template.id}, (res)->
			$location.path("/templates")
		)

	#add section
	$scope.addNewSection = (name, column_id)->
		if !$scope.template.sections
			$scope.template.sections = []
			$scope.template.columns = []
		$scope.template.sections.push name
		$scope.template.columns.push column_id
		$scope.newSectionName = ""
		return

	# add premade section
	# $scope.addPremadeSection = (section) ->
	# 	$scope.template.sections.push section
	# 	$.extend section, new ClassFactory()
	# 	section.template_id = $scope.template.id
	# 	section.$save({class: 'sections'}, (res)->
	# 		refreshTemplate()
	# 	)
	# 	return

	# delete section
	$scope.deleteSection = (template, section) ->
		index = template.sections.indexOf(section)
		template.sections.splice index, 1
		template.columns.splice index, 1
		return

	# create new field
	$scope.addNewField = (template, section_id, column_id, type, name)->
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
		return

	# delete field
	$scope.deleteField = (column, field) ->
		index = column.fields.indexOf(field)
		column.fields.splice index, 1
		$.extend field, new ClassFactory()
		field.$delete({class: 'fields', id: field.id})
		return

	# add field option
	$scope.addOption = (field) ->
		if !field.options then field.options = new Array
		option = new ClassFactory()
		option.name = ''
		option.field_id = field.id
		field.options.push option
		option.$save({class: 'options'})
		return

	# delete particular option
	$scope.deleteOption = (field, option) ->
		index = field.options.indexOf(option)
		field.options.splice index, 1
		$.extend option, new ClassFactory()
		option.$delete({class: 'options', id: option.id})
		return
])