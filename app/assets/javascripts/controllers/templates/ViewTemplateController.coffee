controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$routeParams', '$scope', 'ClassFactory',
($routeParams, $scope, ClassFactory)->
	ClassFactory.get({class: 'templates', id: $routeParams.templateId}, (res)->
		$scope.template = res
		$scope.template.viewing = true
	)
])