controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope', 'TemplatesFactory',
($scope, TemplatesFactory)->
	TemplatesFactory.query().$promise.then((res)->
		$scope.templates = res
		i = 0
		while i < $scope.templates.length
			jsonData = JSON.parse($scope.templates[i].sections)
			$scope.templates[i].sections = $.map(jsonData, (value, index)->
				value.key = index
				return [value]
			)
			i++
	)
	
])
