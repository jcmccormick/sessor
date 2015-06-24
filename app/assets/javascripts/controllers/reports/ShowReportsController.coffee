controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$auth', '$scope', 'ReportsFactory',
($auth, $scope, ReportsFactory)->
	$scope.reports = ReportsFactory.query()
])