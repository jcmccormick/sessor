controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope', 'ClassFactory',
($scope, ClassFactory)->

	$scope.reports = []
	$scope.page = 1

	$scope.search = (keywords)->
		$scope.reports = []
		$scope.page = 1
		$scope.loadNewItems(keywords)

	$scope.loadNewItems = (keywords)->
		if keywords && $scope.page == 1
			$scope.reports = []
		ClassFactory.query({class: 'reports', page: $scope.page, keywords: keywords}, (reports)->
			$scope.reports = $scope.reports.concat(reports)
			$scope.page += 1
			for report in $scope.reports
				sorting = []
				angular.copy report.template_order, sorting
				report.templates = report.templates.map((item) ->
					n = sorting.indexOf(item.id)
					sorting[n] = ''
					[
						n
						item
					]
				).sort().map((j) ->
					j[1]
				)
		)

	$scope.sortTemplates = (report)->
		result = []
		for template_id in report.template_order
			found = false
			report.templates = report.templates.filter((template)->
				if !found && template.id == template_id
					result.push(template)
					found = true
					false
				else
					true
			)
			report.templates = result

])