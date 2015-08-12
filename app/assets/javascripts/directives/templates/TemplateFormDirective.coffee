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
		$scope.setSelectedOptions = (optionSet, form)->
			if form.editing
				form.selectedOptions = optionSet

		$scope.columnsArray = (columns)->
			new Array columns

		# Report Edit Features
		$scope.setBreadcrumb = (template)->
			$scope.form = template

		$scope.addTemplate = (template, myForm, report)->
			report.template_ids.push template.id
			myForm.$dirty = true
			report.saveReport(true, myForm, report).then((res)->
				report.getReport(report.id).then((res)->
					console.log 'what'
					#report.values = res.values
					#report.templates = res.templates
				)
			)

	]}
])