controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope', 'ClassFactory',
($scope, ClassFactory)->

	$scope.page = 1
	$scope.reports = []

	$scope.loadNewItems = ->
		ClassFactory.query({class: 'reports', page: $scope.page}, (reports)->
			$scope.reports = $scope.reports.concat(reports)
			$scope.page += 1
		)

])