controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$auth', '$rootScope', '$scope', '$resource', '$routeParams', '$location', 'TemplateService', 'TemplateFactory', 'ClassFactory',
($auth, $rootScope, $scope, $resource, $routeParams, $location, TemplateService, TemplateFactory, ClassFactory)->

	if $routeParams.templateId
		ClassFactory.get({class: 'templates', id: $routeParams.templateId}).$promise.then((res)->
			$scope.template = res
		)
	else
		$scope.template = new ClassFactory()
		$scope.template.creator_uid = $auth.user.uid

	refreshTemplate = ->
		$rootScope.$broadcast('cleartemplates')
		ClassFactory.get({class: 'templates', id: $scope.template.id}, (res)->
			$scope.template = res
			$scope.loading = ""
		)

	$scope.blurSave = ->
		if !$scope.template.id
			$scope.template.$save({class: 'templates'}, (res)->
				$location.path('templates/'+res.id+'/edit')
			)
		else
			$scope.template.$update({class: 'templates', id: $scope.template.id})

	$scope.sectionTypes = TemplateService.sections
	$scope.columnTypes = TemplateService.columns
	$scope.fieldTypes = TemplateService.fields

	# preview template
	$scope.previewTemplate = {}
	$scope.previewUpdate = ->
		angular.copy $scope.template, $scope.previewTemplate
		return

	#add section
	$scope.addNewSection = (name, column)->
		$scope.loading = "Loading "
		section = new ClassFactory()
		section.name = name
		section.template_id = $scope.template.id
		$scope.template.sections.push section
		section.$save({class: 'sections'}, (res)->
			column.count.forEach((column)->
				column = new ClassFactory()
				column.section_id = res.id
				column.$save({class: 'columns'})
			)
			refreshTemplate()
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
		i = 0
		while i < template.sections.length
			if template.sections[i] == section
				template.sections.splice i, 1
				break
			i++
		$.extend section, new ClassFactory() 
		section.$delete({class: 'sections', id: section.id})
		return

	# create new field
	$scope.addNewField = (column, type, name)->
		field = new ClassFactory()
		field.name = name
		field.fieldtype = type.name
		field.value = ""
		field.required = undefined
		field.disabled = undefined
		field.glyphicon = type.glyphicon
		field.column_id = column.id
		column.fields.push field
		field.$save({class: 'fields'})
		return

	# delete field
	$scope.deleteField = (column, field) ->
		i = 0
		while i < column.fields.length
			if column.fields[i] == field
				column.fields.splice i, 1
				break
			i++
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
		i = 0
		while i < field.options.length
			if field.options[i].id == option.id
				field.options.splice i, 1
				break
			i++
		$.extend option, new ClassFactory()
		option.$delete({class: 'options', id: option.id})
		return

	$scope.saveTemplate = ->
		tempCopy = new ClassFactory()
		angular.copy $scope.template, tempCopy
		tempCopy.$update({class: 'templates', id: tempCopy.id}, (res)->
			$location.path("/templates/#{tempCopy.id}")
			$rootScope.$broadcast('cleartemplates')
		)

	$scope.deleteTemplate = ()->
		$scope.template.$delete({class: 'templates', id: $scope.template.id})
		.then((res)->
			$rootScope.$broadcast('cleartemplates')
			$location.path("/templates"))

])