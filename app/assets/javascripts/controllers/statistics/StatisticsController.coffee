controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['$scope', 'ClassFactory', 'TemplateService',
($scope, ClassFactory, TemplateService)->
	## Var Declare
	$scope.dataProps = []
	$scope.dataProps.templates = []
	$scope.dataProps.fields = []

	$scope.search = []
	$scope.search.key = 'name'
	$scope.search.date = false

	$scope.graphtype = 'pie'

	$scope.needLegend = true

	#Populate User's Templates
	ClassFactory.query({class: 'templates'}, (res)->
		console.log res
		res.forEach((template)->
			$scope.dataProps.templates.push template
		)
	)

	#Take Search Selections and Parse
	$scope.listFields = (template)->
		# for field in template.fields
		# 	$scope.dataProps.fields.push field
		# console.log $scope.dataProps.fields
		# $scope.search.template.fields
		# ClassFactory.query().$promise.then((res)->

		# 	StatisticsService.getCountOfIn($scope.search, res, (collection)->
		# 		$scope.labels = collection[0]
		# 		collection[0].forEach((label)->
		# 			$scope.dataProps.fields[label] = label
		# 		)
		# 	)
	$scope.showData = ->
		# StatisticsService.getCountOfIn($scope.search, res, (collection, fieldData, optionLabels)->
		# 	$scope.labels = fieldData[0]
		# 	console.log optionLabels
		# 	if optionLabels.length > 0
		# 		optionLabels.splice(fieldData[0].length, optionLabels.length)
		# 		$scope.labels = optionLabels

		# 	$scope.pie = fieldData[1]
		# 	$scope.line = []
		# 	$scope.line.push fieldData[1]
		# 	if $.inArray($scope.graphtype, ['pie', 'doughnut', 'polar-area'])
		# 		$scope.data = fieldData[1]
		# 	else
		# 		$scope.data = []
		# 		$scope.data.push fieldData[1]
		# )

	$scope.graphType = (graphtype)->
		$scope.graphtype = graphtype
		if $.inArray(graphtype, ['pie','doughnut','polar-area']) != -1
			$scope.needLegend = true
		else
			$scope.needLegend = false
	#)
])