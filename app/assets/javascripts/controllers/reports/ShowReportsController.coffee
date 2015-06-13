controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope', 'ReportsFactory',
($scope, ReportsFactory)->
	$scope.reports = ReportsFactory.query()
])