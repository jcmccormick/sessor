controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope', 'TemplatesFactory',
($scope, TemplatesFactory)->
	$scope.templates = TemplatesFactory.query()
	i = 0
	while i < $scope.templates.length
		$scope.templates[i].sections = $.parseJSON($scope.templates[i].sections)
		i++
])