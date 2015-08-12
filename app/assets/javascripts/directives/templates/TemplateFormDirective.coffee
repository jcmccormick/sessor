directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		report: '='
	controller: ['$scope',
	($scope)->

		# Template Designer Features
		$scope.setSelectedOptions = (optionSet, selectedOptions, editing)->
			if editing
				selectedOptions = optionSet

		$scope.columnsArray = (columns)->
			new Array columns

		# Report Edit Features
		$scope.setBreadcrumb = (template)->
			$scope.form = template

		$scope.addTemplate = (template, myForm, report)->
			report.template_ids.push template.id
			report.saveReport(true, myForm, report).then((res)->
				report.getReport(report.id).then((res)->
					report.templates = res.templates
					report.values = res.values
				)
			)

	]}
])