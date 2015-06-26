controllers = angular.module('controllers')
controllers.controller("ShowTemplatesController",  ['$scope', 'ParseMapService',
($scope, ParseMapService)->
	$scope.parseTemplateSections = (data, headersGetter)->
		data.forEach (template) ->
			template.sections = ParseMapService.map(template.sections)
		return data	
])
