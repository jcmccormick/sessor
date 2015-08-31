directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		report: '='
	controller: ['$scope', 'ClassFactory',
	($scope, ClassFactory)->

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
			report.addTemplate(template, myForm, report).then((res)->
				$scope.loadNewItems()
			)

		$scope.removeTemplate = (template, report)->
			report.removeTemplate(template, report).then((res)->
				$scope.form = report.templates[0]
				$scope.loadNewItems()
			)

		$scope.loadNewItems = ->
			ClassFactory.query({class: 'templates', ts: [$scope.report.template_order]}, (templates)->
				$scope.templates = templates
			)


	]}
])