controllers = angular.module('controllers')
controllers.controller("ReportsStatisticsController",  ['$scope', 'ReportsFactory', 'StatisticsService', 'TemplateService',
($scope, ReportsFactory, StatisticsService, TemplateService)->
	ReportsFactory.query().$promise.then((res)->
		$scope.dataProps = []
		$scope.dataProps.names = TemplateService.supportedProperties
		$scope.showData = ->
			$scope.count = StatisticsService.getCountOfIn($scope.selectedData, res)
			$scope.labels = $scope.count[0]
			$scope.data = $scope.count[1]
			console.log $scope.dataProps
			console.log $scope.selectedData
			console.log $scope.data
			console.log $scope.labels
			console.log $scope.count
	)
])