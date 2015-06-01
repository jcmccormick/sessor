controllers = angular.module('controllers')
controllers.controller('TemplateController', [ '$scope', '$resource', 'ngDialog', 'TemplateService',
($scope, $resource, ngDialog, TemplateService)->

	# previewForm - for preview purposes, form will be copied into this
	# otherwise, actual form might get manipulated in preview mode
	$scope.previewForm = {}
	$scope.previewMode = false

	# new form
	$scope.form = {}
	$scope.form.form_id = 1
	$scope.form.form_name = ''
	$scope.form.form_sections = []

	# add new field drop-down:
	$scope.addField = {}
	$scope.addField.types = TemplateService.fields
	$scope.addField.new = $scope.addField.types[0].name
	$scope.addField.lastAddedID = 0

	# accordion settings
	$scope.accordion = {}
	$scope.accordion.oneAtATime = true
	
	# add new section option
	$scope.section = {}
	$scope.section.section_columns = 0
	$scope.section.max_columns = 3
	$scope.section.section_fields = []
	$scope.addSection = {}
	$scope.addSection.lastAddedID = 0

	#add section button
	$scope.addNewSection = ()->
		$scope.addSection.lastAddedID++
		newSection = 
			'section_id': $scope.addSection.lastAddedID
			'section_title': $scope.section.section_title
			'section_columns': $scope.section.section_columns
		console.log newSection
		$scope.form.form_sections.push newSection

	#section sub-column manipulation
	$scope.setColumns = (cols)->
		$scope.section.section_columns = cols
		$scope.section.section_column_width = 'col-md-' + (12/cols)
		console.log $scope.section.section_column_width

	# create new field button click
	$scope.addNewField = (type, location)->
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
			'field_id': $scope.addField.lastAddedID
			'field_location': location
			'field_title': user_title
			'field_type': type
			'field_value': ''
			'field_required': true
			'field_disabled': false
			'field_glyphicon': glyphicon
		# put newField into current section
		$scope.section.section_fields.push newField
		return

	# deletes particular field on button click
	$scope.deleteField = (field_id) ->
		i = 0
		while i < $scope.form.form_fields.length
			if $scope.form.form_fields[i].field_id == field_id
				$scope.form.form_fields.splice i, 1
				break
			i++
		return

	# add new option to the field
	$scope.addOption = (field) ->
		if !field.field_options
			field.field_options = new Array
		lastOptionID = 0
		if field.field_options[field.field_options.length - 1]
			lastOptionID = field.field_options[field.field_options.length - 1].option_id
		# new option's id
		option_id = lastOptionID + 1
		newOption = 
			'option_id': option_id
			'option_title': 'Option ' + option_id
			'option_value': option_id
		# put new option into field_options array
		field.field_options.push newOption
		return

	# delete particular option

	$scope.deleteOption = (field, option) ->
		i = 0
		while i < field.field_options.length
			if field.field_options[i].option_id == option.option_id
				field.field_options.splice i, 1
				break
			i++
		return

	# preview form

	$scope.previewOn = ->
		if $scope.form.form_fields == null or $scope.form.form_fields.length == 0
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
		if field.field_type == 'radio' or field.field_type == 'dropdown'
			true
		else
			false

	# deletes all the fields

	$scope.reset = ->
		$scope.form.form_fields.splice 0, $scope.form.form_fields.length
		$scope.addField.lastAddedID = 0
		$scope.previewMode = false
		return

	$scope.getNumber = (num)->
		return new Array(num)
])