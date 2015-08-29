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
				if res != 'updated'
					report.template_ids.pop()
				else
					report.getReport(report.id).then((rep)->
						report.templates.push rep.templates[rep.templates.length-1]
					)
			)

		$scope.removeTemplate = (template, report)->
			report.removeTemplate(template, report).then((res)->
				if res == 'deleted'
					index = report.templates.indexOf(template)
					report.templates.splice index, 1
					idindex = report.template_ids.indexOf(template.id)
					report.template_ids.splice idindex, 1
					if $scope.form.id == template.id
						$scope.form = report.templates[0]
			)

		$scope.page = 1
		$scope.templates = []

		$scope.loadNewItems = ->
			ClassFactory.query({class: 'templates', page: $scope.page}, (templates)->
				$scope.templates = $scope.templates.concat(templates)
				$scope.page += 1
			)


	]}
])