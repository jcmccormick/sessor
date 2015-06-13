controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$scope', '$routeParams', 'TemplateFactory',
($scope, $routeParams, TemplateFactory)->
	$scope.template = TemplateFactory.get({id: $routeParams.templateId})
	console.log $scope.template.sections
])