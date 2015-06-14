controllers = angular.module('controllers')
controllers.controller('EditTemplateController', ['$rootScope', '$scope', '$resource', '$routeParams', '$location', 'TemplateService', 'TemplateFactory'
($rootScope, $scope, $resource, $routeParams, $location, TemplateService, TemplateFactory)->

	# add new section options
	$scope.addSection = {}
	$scope.addSection.lastAddedID = 0
	$scope.addSection.prototype = {}
	$scope.addSection.columns = {}
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
		$scope.template.sections.columns = []
		$scope.template.sections.columns.fields = []

	
	# preview template
	$scope.previewTemplate = {}
	$scope.previewUpdate = ->
		console.log $scope.template
		angular.copy $scope.template, $scope.previewTemplate
		return

	#add section button
	$scope.addNewSection = (column)->
		i = 0
		while i < column.id
			$scope.addSection.columns.lastAddedID++
			newColumn = 
				'id': $scope.addSection.columns.lastAddedID
				'width': column.width
				'fields': []
			$scope.addSection.columns.push newColumn
			i++
		title = if $scope.addSection.title? then $scope.addSection.title else "Untitled Section"
		$scope.addSection.lastAddedID++
		newSection = 
			'id': $scope.addSection.lastAddedID
			'title': title
			'columns': $scope.addSection.columns
		$scope.template.sections.push newSection
		$scope.addSection.title = ''
		$scope.addSection.columns = []
		$scope.addSection.columns.lastAddedID = 0
		return

	# add new option to the field
	$scope.addPremadeSection = (sec) ->
		$scope.addSection.lastAddedID++
		angular.copy sec, $scope.addSection.prototype
		$scope.addSection.prototype.id = $scope.addSection.lastAddedID
		$scope.template.sections.push $scope.addSection.prototype
		$scope.addSection.prototype = {}
		return

	# delete section button
	$scope.deleteSection = (sec) ->
		sections = $scope.template.sections
		i = 0
		while i < sections.length
			if sections[i].id == sec
				sections.splice i, 1
				break
			i++
		return

	# create new field button click
	$scope.addNewField = (type, sec, col, title)->
		$scope.location = $scope.template.sections[sec-1].columns[col-1]
		title = if title? then title else "Untitled "+type
		#collect glyphicon class of scoped type
		i = 0
		while i < $scope.addField.types.length
			if $scope.addField.types[i].name == type
				glyphicon = $scope.addField.types[i].glyphicon
				break
			i++
		$scope.addField.lastAddedID = $scope.location.fields.length
		$scope.addField.lastAddedID++
		newField = 
			'id': $scope.addField.lastAddedID
			'section': sec
			'column': col
			'title': title
			'type': type
			'value': ''
			'required': false
			'disabled': false
			'glyphicon': glyphicon
		# put newField into current column
		$scope.template.sections[sec-1].columns[col-1].fields.push newField
		return

	# deletes particular field on button click
	$scope.deleteField = (id, sec, col) ->
		fields = $scope.template.sections[sec-1].columns[col-1].fields
		i = 0
		while i < fields.length
			if fields[i].id == id
				fields.splice i, 1
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
			'title': 'Option ' + id
			'value': id
		# put new option into options array
		field.options.push newOption
		return

	# delete particular option

	$scope.deleteOption = (field, sec, col, option) ->
		options = $scope.template.sections[sec-1].columns[col-1].fields[field-1].options
		i = 0
		while i < options.length
			if options[i].id == option.id
				options.splice i, 1
				break
			i++
		return


	# deletes all the fields

	$scope.resetTemplate = ->
		$scope.template.name = ''
		$scope.template.sections.splice 0, $scope.template.sections.length
		$scope.addSection.lastAddedID = 0
		$scope.addField.lastAddedID = 0
		return

	$scope.saveTemplate = ->
		tempCopy = new TemplateFactory()
		console.log $scope.template
		angular.copy $scope.template, tempCopy
		console.log tempCopy
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