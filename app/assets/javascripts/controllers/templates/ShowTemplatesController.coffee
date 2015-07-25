controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope',
($scope)->
	$scope.keywords = ''
	$scope.$watch 'keywords', (keywords)->
		$scope.urlParams = if keywords.length > 0
			{ keywords: keywords }
		else
			{}
		return
])
