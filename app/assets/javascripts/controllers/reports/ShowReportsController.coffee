controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope',
($scope)->
	$scope.setParams = ->
		$scope.urlParams = if $scope.keywords.length > 0
			{ keywords:$scope.keywords }
		else
			{}
])