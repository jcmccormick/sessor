controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', '$location', 'ReportFactory',
($scope, $routeParams, $location, ReportFactory)->
	TemplateFactory.get({id: $routeParams.reportId}).$promise.then((res)->
		$scope.report = res
		jsonData = JSON.parse($scope.report.sections)
		$scope.report.sections = $.map(jsonData, (value, index)->
			value.key = index
			return [value]
		)
	)

])