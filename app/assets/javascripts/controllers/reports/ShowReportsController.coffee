controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['$scope', 'ParseMapService',
($scope, ParseMapService)->
	$scope.parseReportTemplate = (data, headersGetter)->
		data.forEach (report) ->
			report.sections = ParseMapService.map(report.template)
		return data
])