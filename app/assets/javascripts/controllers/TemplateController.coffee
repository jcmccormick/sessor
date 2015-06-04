controllers = angular.module('controllers')
controllers.controller('TemplateController', [ '$scope', '$resource', 'ngDialog', 'TemplateService',
($scope, $resource, ngDialog, TemplateService)->

	# previewForm - for preview purposes, form will be copied into this
	# otherwise, actual form might get manipulated in preview mode
	$scope.previewForm = {}
	$scope.previewMode = false

	# accordion settings
	$scope.accordion = {}
	$scope.accordion.oneAtATime = true
	
	# new form
	$scope.form = {}
	$scope.form.id = 1
	$scope.form.name = ''
	$scope.form.sections = []

	# add new field option
	$scope.addField = {}
	$scope.addField.types = TemplateService.fields
	$scope.addField.new = $scope.addField.types[0].name
	$scope.addField.lastAddedID = 0

	# add new section option
	$scope.section = {}
	$scope.addSection = {}
	$scope.addSection.columns = []
	$scope.addSection.lastAddedID = 0

	# add new column option
	$scope.section.column = {}
	$scope.section.columns = []
	$scope.addColumn = {}
	$scope.addColumn.lastAddedID = 0
	$scope.section.column.fields = []

	#add section button
	$scope.addNewSection = ()->
		$scope.addSection.lastAddedID++
		newSection = 
			'id': $scope.addSection.lastAddedID
			'title': $scope.addSection.title
			'columns': $scope.addSection.columns
		$scope.form.sections.push newSection
		return

	#section sub-column manipulation
	$scope.addNewColumns = (cols)->
		i = 0
		while i < cols
			$scope.addColumn.lastAddedID++
			newColumn = 
				'id': $scope.addColumn.lastAddedID
				'width': 'col-md-' + (12/cols)
			$scope.addSection.columns.push newColumn
			i++
		return

	# create new field button click
	$scope.addNewField = (type)->
		if !user_title = prompt('What would you like to name this ' + type + '?')
			user_title = "Untitled " + type + " field"
		i = 0

		#collect glyphicon class of scoped type
		while i < $scope.addField.types.length
			if $scope.addField.types[i].name == type
				glyphicon = $scope.addField.types[i].glyphicon
				break
			i++
		$scope.addField.lastAddedID++
		newField = 
			'id': $scope.addField.lastAddedID
			'title': user_title
			'type': type
			'value': ''
			'required': true
			'disabled': false
			'glyphicon': glyphicon
		# put newField into current column
		$scope.section.column.fields.push newField
		return

	# deletes particular field on button click
	$scope.deleteField = (id) ->
		i = 0
		while i < $scope.form.fields.length
			if $scope.form.fields[i].id == id
				$scope.form.fields.splice i, 1
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

	$scope.deleteOption = (field, option) ->
		i = 0
		while i < field.options.length
			if field.options[i].id == option.id
				field.options.splice i, 1
				break
			i++
		return

	# preview form

	$scope.previewOn = ->
		if $scope.form.fields == null or $scope.form.fields.length == 0
			title = 'Error'
			msg = 'No fields added yet, please add fields to the form before preview.'
			btns = [ {
				result: 'ok'
				label: 'OK'
				cssClass: 'btn-primary'
			} ]
			ngDialog.open(title, msg, btns)
		else
			$scope.previewMode = !$scope.previewMode
			$scope.form.submitted = false
			angular.copy $scope.form, $scope.previewForm
		return

	# hide preview form, go back to create mode

	$scope.previewOff = ->
		$scope.previewMode = !$scope.previewMode
		$scope.form.submitted = false
		return

	# decides whether field options block will be shown (true for dropdown and radio fields)

	$scope.showAddOptions = (field) ->
		if field.type == 'radio' or field.type == 'dropdown'
			true
		else
			false

	# deletes all the fields

	$scope.reset = ->
		$scope.form.fields.splice 0, $scope.form.fields.length
		$scope.addField.lastAddedID = 0
		$scope.previewMode = false
		return

	$scope.getNumber = (num)->
		return new Array(num)
])