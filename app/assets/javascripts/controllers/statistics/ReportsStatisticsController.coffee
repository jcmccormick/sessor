controllers = angular.module('controllers')
controllers.controller("ReportsStatisticsController",  ['$scope', 'ReportsFactory', 'StatisticsService', 'TemplateService',
($scope, ReportsFactory, StatisticsService, TemplateService)->
	ReportsFactory.query().$promise.then((res)->
		$scope.dataProps = []
		$scope.dataProps.names = TemplateService.supportedProperties
		$scope.graphtype = 'pie'
		$scope.showData = ->
			StatisticsService.getCountOfIn($scope.selectedData, res, (callback)->
				$scope.labels = callback[0]
				$scope.pie = callback[1]
				$scope.line = []
				$scope.line.push callback[1]
				console.log $scope.labels
				console.log $scope.pie
				console.log $scope.line
				$scope.data = callback[1]
			)
	)
])