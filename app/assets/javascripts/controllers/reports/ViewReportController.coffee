controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', 'ReportFactory', 'ClassFactory',
($scope, $routeParams, ReportFactory, ClassFactory)->
	# ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
	# 	$scope.report = res
	# )

	ClassFactory.get({class: 'reports', id: $routeParams.reportId}).$promise.then((res)->
		$scope.report = res
	)
])