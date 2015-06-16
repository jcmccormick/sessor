controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', 'ReportFactory',
($scope, $routeParams, ReportFactory)->
	ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
		$scope.report = res
	)
])