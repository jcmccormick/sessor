controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$auth', '$rootScope', '$scope', '$resource', '$routeParams', '$location', 'ClassFactory', 'Flash', 'TemplateService'
($auth, $rootScope, $scope, $resource, $routeParams, $location, ClassFactory, Flash, TemplateService)->

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

	$scope.saveTemplate = (temp)->
		if $scope.template.name.search(/^[a-zA-Z ]*[a-zA-Z0-9 ]*$/) == -1
			Flash.create('error', 'Title must begin with a letter and only contain letters and numbers.')
		else
			$rootScope.$broadcast('cleartemplates')
			if !$scope.template.id
				$scope.template.$save({class: 'templates'}, (res)->
					$location.path('templates/'+res.id+'/edit')
				)
			else
				$scope.template.sections_attributes = $scope.template.sections
				$scope.template.sections && $scope.template.sections_attributes.forEach((section)->
					section.columns_attributes = section.columns
					section.columns && section.columns_attributes.forEach((column)->
						column.fields_attributes = column.fields
						column.fields && column.fields_attributes.forEach((field)->
							field.options_attributes = field.options
							field.values_attributes = field.values
						)
					)
				)
				$scope.template.$update({class: 'templates', id: $scope.template.id}, (res)->
					if !temp
						$location.path("/templates/#{res.id}")
				)

	$scope.deleteTemplate = ->
		$rootScope.$broadcast('cleartemplates')
		$scope.template.$delete({class: 'templates', id: $scope.template.id}, (res)->
			$location.path("/templates")
		)

	# separate preview from actual template
	$scope.previewUpdate = ->
		angular.copy $scope.template, $scope.previewTemplate
		return

	#add section
	$scope.addNewSection = (name, column)->
		section = new ClassFactory()
		section.name = name
		section.template_id = $scope.template.id
		section.$save({class: 'sections'}, (res)->
			res.columns = new Array
			column.count.forEach((column)->
				column = new ClassFactory()
				column.section_id = res.id
				column.$save({class: 'columns'}, (col)->
					res.columns.push col
				)
			)
			$scope.template.sections.push res
		)
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
		$.extend section, new ClassFactory() 
		section.$delete({class: 'sections', id: section.id})
		return

	# create new field
	$scope.addNewField = (column, type, name)->
		if !column.fields then column.fields = new Array
		field = new ClassFactory()
		field.name = name
		field.fieldtype = type.name
		field.required = undefined
		field.disabled = undefined
		field.glyphicon = type.glyphicon
		field.column_id = column.id
		field.$save({class: 'fields'}, (res)->
			field.values = []
			value = new ClassFactory()
			value.field_id = res.id
			value.$save({class: 'values'}, (val)->
				field.values.push val
				column.fields.push res
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