controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['$scope', 'ClassFactory', 'TemplateService', 'StatisticsService',
($scope, ClassFactory, TemplateService, StatisticsService)->
	## Var Declare
	$scope.dataProps = []
	$scope.dataProps.templates = []
	$scope.dataProps.fields = []
	$scope.dataProps.values = []

	$scope.search = []
	$scope.search.key = 'name'
	$scope.search.date = {}
	$scope.search.time = {}

	$scope.labels = []
	$scope.pie = []
	$scope.line = []


	$scope.graphtype = 'pie'

	$scope.needLegend = true

	#Populate User's Templates
	ClassFactory.query({class: 'values_statistics'}, (res)->
		for template in res
			$scope.dataProps.templates.push template
	)

	#Take Search Selections and Parse
	$scope.listFields = (template)->
		ClassFactory.query({class: 'fields', template_id: template.id, stats: true}, (res)->
			$scope.dataProps.fields = res
		)

	$scope.showData = (field)->
		ClassFactory.query({class: 'values', field_id: field.id, stats: true}, (res)->
			res.forEach((value)->
				console.log value
				$scope.dataProps.values.push value.input
			)
			console.log field
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
		)

	$scope.graphType = (graphtype)->
		$scope.graphtype = graphtype
		if $.inArray(graphtype, ['pie','doughnut','polar-area']) != -1
			$scope.needLegend = true
		else
			$scope.needLegend = false
	#)
])