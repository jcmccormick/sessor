controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope', 'ClassFactory',
($scope, ClassFactory)->

	$scope.page = 1
	$scope.templates = []

	$scope.loadNewItems = ->
		ClassFactory.query({class: 'templates', page: $scope.page}, (templates)->
			$scope.templates = $scope.templates.concat(templates)
			$scope.page += 1
		)
])
