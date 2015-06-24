controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope', 'TemplatesFactory',
($scope, TemplatesFactory)->
	TemplatesFactory.query().$promise.then((res)->
		$scope.templates = res
	).then().catch((err)->console.log err.data)
	
])
