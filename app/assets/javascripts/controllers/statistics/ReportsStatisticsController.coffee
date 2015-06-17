controllers = angular.module('controllers')
controllers.controller("ReportsStatisticsController",  ['$scope', 'ReportsFactory', 'StatisticsService', 'TemplateService',
($scope, ReportsFactory, StatisticsService, TemplateService)->
	ReportsFactory.query().$promise.then((res)->
		$scope.dataProps = []
		$scope.dataProps.names = {}
		$scope.dataProps.fields = {}
		$scope.dataProps.names = TemplateService.supportedProperties
		$scope.graphtype = 'pie'
		StatisticsService.getCountOfIn('name', res, (callback)->
			$scope.labels = callback[0]
			callback[0].forEach((label)->
				$scope.dataProps.fields[label] = label
				
			)
			StatisticsService.getCountOfIn($scope.selectedField, res, (callback, fields)->
				$scope.pie = callback[1]
				$scope.line = []
				$scope.line.push callback[1]
			)
		)
		$scope.showData = ->
			StatisticsService.getCountOfIn($scope.selectedField, res, (callback)->
				$scope.labels = callback[0]
				$scope.pie = callback[1]
				$scope.line = []
				$scope.line.push callback[1]
			)
	)
])