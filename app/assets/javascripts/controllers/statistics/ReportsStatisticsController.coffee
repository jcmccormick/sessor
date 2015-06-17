controllers = angular.module('controllers')
controllers.controller("ReportsStatisticsController",  ['$scope', 'ReportsFactory', 'StatisticsService', 'TemplateService',
($scope, ReportsFactory, StatisticsService, TemplateService)->
	$scope.dataProps = []
	$scope.dataProps.names = {}
	$scope.dataProps.fields = {}
	$scope.dataProps.names = TemplateService.supportedProperties
	$scope.graphtype = 'pie'
	$scope.line = []

	ReportsFactory.query().$promise.then((res)->

		StatisticsService.getCountOfIn('name ', res, (collection)->
			$scope.labels = collection[0]
			collection[0].forEach((label)->
				$scope.dataProps.fields[label] = label
			)
		)

		$scope.showData = ->
			StatisticsService.getCountOfIn('name '+$scope.selectedField, res, (collection, fieldData)->
				$scope.labels = fieldData[0]
				$scope.pie = fieldData[1]
				$scope.line = []
				$scope.line.push fieldData[1]
			)
	)
])