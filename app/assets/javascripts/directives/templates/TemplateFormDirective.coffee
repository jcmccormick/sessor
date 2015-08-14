directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		report: '='
	controller: ['$scope', 'ReportsService',
	($scope, ReportsService)->

		# Template Designer Features
		$scope.setSelectedOptions = (optionSet, form)->
			if form.editing
				form.selectedOptions = optionSet

		$scope.columnsArray = (columns)->
			new Array columns

		# Report Edit Features
		$scope.setBreadcrumb = (template)->
			$scope.form = template

		$scope.addTemplate = (template, myForm, report)->
			myForm.$dirty = true
			report.template_ids.push template.id
			report.saveReport(true, myForm, report).then((res)->
				if !res.templates
					report.template_ids.pop()
				else
					report = res
			)

	]}
])