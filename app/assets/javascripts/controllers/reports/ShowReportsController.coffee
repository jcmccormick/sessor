controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope', 'ClassFactory',
($scope, ClassFactory)->
	$scope.keywords = ''
	$scope.$watch 'keywords', (keywords)->
		$scope.urlParams = if keywords.length > 0
			{ keywords: keywords }
		else
			{}
		return
])