controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$scope', '$routeParams', '$location', 'TemplatesFactory', 'ReportFactory',
($rootScope, $scope, $routeParams, $location, TemplatesFactory, ReportFactory)->

	TemplatesFactory.query().$promise.then((res)->
		$scope.templates = res
		i = 0
		while i < $scope.templates.length
			jsonData = JSON.parse($scope.templates[0].sections)
			$scope.templates[i].sections = $.map(jsonData, (value, index)->
				value.key = index
				return [value]
			)
			i++
	)

	if $routeParams.reportId
		$scope.report = ReportFactory.get({id: $routeParams.reportId})
	else
		$scope.report = new ReportFactory()


	console.log $scope.report


	$scope.saveReport  = ->
		$scope.report.sections = JSON.stringify($scope.report.sections)
		console.log $scope.report
		if $scope.report.id
			$scope.report.$update({id: $scope.report.id}, (res)->
				$location.path("/reports/#{$scope.report.id}")
				$rootScope.$broadcast('clearreports')
			)
		else
			$scope.report.$save({}, (res)->
				$location.path("/reports/#{$scope.report.id}")
				$rootScope.$broadcast('clearreports')
			)

	$scope.deleteReport = ()->
		$scope.report.$delete({id: $scope.report.id})
		.then((res)->
			$rootScope.$broadcast('clearreports')
			$location.path("/reports"))
])