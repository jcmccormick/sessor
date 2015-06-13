controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$scope', '$routeParams', '$location', 'ReportFactory',
($rootScope, $scope, $routeParams, $location, ReportFactory)->

	if $routeParams.reportId
		$scope.report = ReportFactory.get({id: $routeParams.reportId})
	else
		$scope.report = new ReportFactory()

	$scope.saveReport  = ->
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