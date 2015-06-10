controllers = angular.module('controllers')
controllers.controller('TemplateController', [ '$scope', '$resource', 'TemplateService',
($scope, $resource, TemplateService)->

	# previewForm - for preview purposes, form will be copied into this
	# otherwise, actual form might get manipulated in preview mode
	$scope.previewForm = {}
	
	# new form
	$scope.form = {}
	$scope.form.id = 1
	$scope.form.name = ''
	$scope.form.sections = []
	$scope.form.sections.columns = []
	$scope.form.sections.columns.fields = []

	# add new section options
	$scope.addSection = {}
	$scope.addSection.lastAddedID = 0
	$scope.addSection.columns = []
	$scope.addSection.columns.lastAddedID = 0

	# add new column options
	$scope.addColumn = []
	$scope.addColumn.lastAddedID = 0

	# add new field options
	$scope.addField = {}
	$scope.addField.lastAddedID = 0
	$scope.addField.types = TemplateService.fields

	#add section button
	$scope.addNewSection = (cols)->
		i = 0
		while i < cols
			$scope.addSection.columns.lastAddedID++
			newColumn = 
				'id': $scope.addSection.columns.lastAddedID
				'width': 'col-md-' + (12/cols) + ' col-sm-' + (12/cols) + ' col-xs-' + (12/cols)
				'fields': []
			$scope.addSection.columns.push newColumn
			i++
		$scope.addSection.lastAddedID++
		title = if $scope.addSection.title? then $scope.addSection.title else "Untitled Section"
		newSection = 
			'id': $scope.addSection.lastAddedID
			'title': title
			'columns': $scope.addSection.columns
		$scope.form.sections.push newSection
		$scope.addSection.title = undefined
		$scope.addSection.columns = []
		$scope.addSection.columns.lastAddedID = 0
		return

	# delete section button
	$scope.deleteSection = (sec) ->
		sections = $scope.form.sections
		i = 0
		while i < sections.length
			if sections[i].id == sec
				sections.splice i, 1
				break
			i++
		return

	# create new field button click
	$scope.addNewField = (type, sec, col, title)->
		title = if title? then title else "Untitled "+type
		#collect glyphicon class of scoped type
		i = 0
		while i < $scope.addField.types.length
			if $scope.addField.types[i].name == type
				glyphicon = $scope.addField.types[i].glyphicon
				break
			i++
		$scope.addField.lastAddedID++
		newField = 
			'id': $scope.addField.lastAddedID
			'section': sec
			'column': col
			'title': title
			'type': type
			'value': undefined
			'required': false
			'disabled': false
			'glyphicon': glyphicon
		# put newField into current column
		$scope.form.sections[sec-1].columns[col-1].fields.push newField
		return

	# deletes particular field on button click
	$scope.deleteField = (id, sec, col) ->
		fields = $scope.form.sections[sec-1].columns[col-1].fields
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
		options = $scope.form.sections[sec-1].columns[col-1].fields[field-1].options
		i = 0
		while i < options.length
			if options[i].id == option.id
				options.splice i, 1
				break
			i++
		return

	# preview form

	$scope.previewUpdate = ->
		angular.copy $scope.form, $scope.previewForm
		return

	# deletes all the fields

	$scope.resetForm = ->
		$scope.form.name = ''
		$scope.form.sections.splice 0, $scope.form.sections.length
		$scope.addSection.lastAddedID = 0
		$scope.addField.lastAddedID = 0
		return
])