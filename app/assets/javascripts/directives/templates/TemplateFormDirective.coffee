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
			myForm.$dirty = true
			report.template_order.push template.id
			report.saveReport(true, myForm, report).then((res)->
				report.getReport(report.id).then((rep)->
					if rep.templates[rep.templates.length-1].id != template.id
						report.template_order.pop()
					else
						report.templates.push rep.templates[rep.templates.length-1]
						$scope.loadNewItems()
				)
			)

		$scope.removeTemplate = (template, report)->
			report.removeTemplate(template, report).then((res)->
				if res == 'deleted'
					index = report.templates.indexOf(template)
					report.templates.splice index, 1
					idindex = report.template_order.indexOf(template.id)
					report.template_order.splice idindex, 1
					if $scope.form.id == template.id
						$scope.form = report.templates[0]
					$scope.loadNewItems()
			)


		$scope.loadNewItems = ->
			ClassFactory.query({class: 'templates', ts: [$scope.report.template_order]}, (templates)->
				$scope.templates = templates
			)


	]}
])