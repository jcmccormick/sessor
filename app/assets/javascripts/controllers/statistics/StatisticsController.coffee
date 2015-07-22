controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['$scope', 'ClassFactory', 'TemplateService', 'StatisticsService',
($scope, ClassFactory, TemplateService, StatisticsService)->
	## Var Declare
	$scope.dataProps = []
	$scope.dataProps.templates = []
	$scope.dataProps.fields = []

	$scope.search = []
	$scope.search.key = 'name'
	$scope.search.date = {}
	$scope.search.time = {}


	$scope.graphtype = 'pie'

	$scope.needLegend = true

	#Populate User's Templates
	ClassFactory.query({class: 'values_statistics'}, (res)->
		for template in res
			$scope.dataProps.templates.push template
	)

	#Take Search Selections and Parse
	$scope.listFields = (template)->
		$scope.dataProps.fields = template.fields

	$scope.showData = (field)->
		$scope.labels = []
		$scope.pie = []
		$scope.line = []
		$scope.dataProps.values = []
		for value in field.values
			time_test = new Date(value.updated_at)
			if value.input 
				if !(time_test < $scope.search.date.startDate && time_test > $scope.search.date.endDate)
					if !(time_test < $scope.search.time.startTime && time_test > $scope.search.date.endTime)
						$scope.dataProps.values.push value.input
		console.log $scope.dataProps.values[0]
		console.log $scope.search.date
		console.log $scope.search.time
		$scope.all_data = StatisticsService.countD($scope.dataProps.values)

		$scope.labels = $scope.all_data[0]

		$scope.pie = $scope.all_data[1]
		$scope.line.push $scope.all_data[1]
		if $.inArray($scope.graphtype, ['pie', 'doughnut', 'polar-area'])
			$scope.data = $scope.all_data[1]
		else
			$scope.data = []
			$scope.data.push $scope.all_data[1]

	$scope.graphType = (graphtype)->
		$scope.graphtype = graphtype
		if $.inArray(graphtype, ['pie','doughnut','polar-area']) != -1
			$scope.needLegend = true
		else
			$scope.needLegend = false
	#)
])