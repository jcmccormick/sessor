controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$auth', '$scope', 'ReportsFactory',
($auth, $scope, ReportsFactory)->
	console.log $auth.user.uid
	$scope.reports = ReportsFactory.query({participants: $auth.user.uid})
])