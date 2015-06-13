controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$scope', '$routeParams', 'TemplateFactory',
($scope, $routeParams, TemplateFactory)->
	TemplateFactory.get({id: $routeParams.templateId}).$promise.then((res)->
		$scope.template = res
		jsonData = JSON.parse($scope.template.sections)
		$scope.template.sections = $.map(jsonData, (value, index)->
			value.key = index
			return [value]
		)
	)
])