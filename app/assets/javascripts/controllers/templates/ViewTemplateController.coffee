controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$scope', '$routeParams', 'TemplateFactory',
($scope, $routeParams, TemplateFactory)->
	TemplateFactory.get({id: $routeParams.templateId}).$promise.then((res)->
		$scope.template = res
	)
])