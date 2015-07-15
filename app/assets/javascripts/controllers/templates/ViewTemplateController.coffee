controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$scope', '$routeParams', 'TemplateFactory', 'ClassFactory',
($scope, $routeParams, TemplateFactory, ClassFactory)->
	#TemplateFactory.get({id: $routeParams.templateId}).$promise.then((res)->
	#	$scope.template = res
	#)
	ClassFactory.get({class: 'templates', id: $routeParams.templateId}).$promise.then((res)->
		$scope.template = res
	)
])