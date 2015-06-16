controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$rootScope', '$scope', '$resource', '$routeParams', '$location', 'TemplateService', 'TemplateFactory'
($rootScope, $scope, $resource, $routeParams, $location, TemplateService, TemplateFactory)->

	# add new section options
	$scope.addSection = {}
	$scope.addSection.lastAddedID = 0
	$scope.addSection.prototype = {}
	$scope.addSection.columns = []
	$scope.addSection.columns.lastAddedID = 0
	$scope.addSection.types = TemplateService.sections

	# add new column options
	$scope.addColumn = {}
	$scope.addColumn.lastAddedID = 0
	$scope.addColumn.types = TemplateService.columns

	# add new field options
	$scope.addField = {}
	$scope.addField.lastAddedID = 0
	$scope.addField.types = TemplateService.fields

	if $routeParams.templateId
		TemplateFactory.get({id: $routeParams.templateId}).$promise.then((res)->
			$scope.template = res
			jsonData = JSON.parse($scope.template.sections)
			$scope.template.sections = $.map(jsonData, (value, index)->
				value.key = index
				return [value]
			)
			$scope.addSection.lastAddedID = $scope.template.sections.length
		)
	else
		$scope.template = new TemplateFactory()
		$scope.template.name = ''
		$scope.template.sections = []

	
	# preview template
	$scope.previewTemplate = {}
	$scope.previewUpdate = ->
		angular.copy $scope.template, $scope.previewTemplate
		return

	#add section button
	$scope.addNewSection = (column)->
		i = 0
		while i < column.id
			newColumn = 
				'id': $scope.addSection.columns.lastAddedID
				'sec': $scope.addSection.lastAddedID
				'width': column.width
				'fields': []
			$scope.addSection.columns.push newColumn
			$scope.addSection.columns.lastAddedID++
			i++
		if !$scope.addSection.name
			name = "Unnamed Section"
		newSection = 
			'id': $scope.addSection.lastAddedID
			'name': name
			'columns': $scope.addSection.columns
		$scope.template.sections.push newSection
		$scope.addSection.lastAddedID++
		$scope.addSection.name = ''
		$scope.addSection.columns = []
		$scope.addSection.columns.lastAddedID = 0
		return

	# add new option to the field
	$scope.addPremadeSection = (sec) ->
		sec.id = $scope.addSection.lastAddedID
		$scope.addSection.prototype = {}
		angular.copy sec, $scope.addSection.prototype
		$scope.template.sections.push $scope.addSection.prototype
		$scope.addSection.lastAddedID++
		return

	# delete section button
	$scope.deleteSection = (template, section) ->
		i = 0
		while i < template.sections.length
			if template.sections[i].id == section.id
				template.sections.splice i, 1
				break
			i++
		return

	# create new field button click
	$scope.addNewField = (column, type, name)->
		column.nextFieldID = 0
		if column.fields
			column.nextFieldID = column.fields.length
		if !name
			name = "Unnamed " + type.value
		newField = 
			'id': column.nextFieldID
			'section': column.sec
			'column': column.id
			'name': name
			'type': type.name
			'value': ''
			'required': false
			'disabled': false
			'glyphicon': type.glyphicon
		column.fields.push newField
		column.nextFieldID++
		return

	# deletes particular field on button click
	$scope.deleteField = (column, field) ->
		i = 0
		while i < column.fields.length
			if column.fields[i].id == field.id
				column.fields.splice i, 1
				break
			i++
		return

	# add new option to the field
	$scope.addOption = (field) ->
		if !field.options
			field.options = new Array
		lastOptionID = 0
		if field.options[field.options.length - 1]
			lastOptionID = field.options[field.options.length - 1].id
		# new option's id
		id = lastOptionID + 1
		newOption = 
			'id': id
			'name': 'Option ' + id
			'value': id
		# put new option into options array
		field.options.push newOption
		return

	# delete particular option
	$scope.deleteOption = (field, option) ->
		options = field.options
		i = 0
		while i < options.length
			if options[i].id == option.id
				options.splice i, 1
				break
			i++
		return


	# deletes all the fields
	$scope.resetTemplate = ->
		$scope.template.sections.splice 0, $scope.template.sections.length
		$scope.template = new TemplateFactory()
		$scope.template.name = ''
		$scope.template.sections = []
		$scope.addSection.lastAddedID = 0
		$scope.addSection.columns.lastAddedID = 0
		$scope.addColumn.lastAddedID = 0
		$scope.addField.lastAddedID = 0
		return

	$scope.saveTemplate = ->
		tempCopy = new TemplateFactory()
		angular.copy $scope.template, tempCopy
		tempCopy.sections = JSON.stringify(tempCopy.sections)
		if tempCopy.id
			tempCopy.$update({id: tempCopy.id}, (res)->
				$location.path("/templates/#{tempCopy.id}")
				$rootScope.$broadcast('cleartemplates')
			)
		else
			tempCopy.$save({}, (res)->
				$location.path("/templates/#{tempCopy.id}")
				$rootScope.$broadcast('cleartemplates')
			).catch((err)-> console.log err.data)

	$scope.deleteTemplate = ()->
		$scope.template.$delete({id: $scope.template.id})
		.then((res)->
			$rootScope.$broadcast('cleartemplates')
			$location.path("/templates"))

])