controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$scope', '$routeParams', '$location', 'TemplatesFactory', 'ReportFactory',
($rootScope, $scope, $routeParams, $location, TemplatesFactory, ReportFactory)->
	if $routeParams.reportId
		ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
			$scope.report = res
			$scope.report.livesave = true
			jsonData = JSON.parse($scope.report.template)
			$scope.report.sections = $.map(jsonData, (value, index)->
				value.key = index
				return [value]
			)
		)
	else
		$scope.report = new ReportFactory()
		$scope.report.livesave = true
		TemplatesFactory.query().$promise.then((res)->
			$scope.templates = res
			i = 0
			while i < $scope.templates.length
				jsonData = JSON.parse($scope.templates[i].sections)
				$scope.templates[i].sections = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				i++
		)
])