controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', '$location', 'ReportFactory',
($scope, $routeParams, $location, ReportFactory)->
	$scope.report = ReportFactory.get({id: $routeParams.reportId})

])