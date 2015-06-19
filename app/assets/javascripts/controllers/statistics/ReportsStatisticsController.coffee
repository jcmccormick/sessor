controllers = angular.module('controllers')
controllers.controller("ReportsStatisticsController",  ['$scope', 'ReportsFactory', 'StatisticsService', 'TemplatesFactory', 'TemplateService',
($scope, ReportsFactory, StatisticsService, TemplatesFactory, TemplateService)->
	$scope.dataProps = []
	$scope.dataProps.names = {}
	$scope.dataProps.fields = {}
	$scope.dataProps.templates = {}
	$scope.search = []
	$scope.search.key = 'name'

	$scope.graphtype = 'pie'
	$scope.needLegend = true

	TemplatesFactory.query().$promise.then((res)->
		res.forEach((template)->
			$scope.dataProps.templates[template.id] = template.name
		)
	)

	$scope.dataProps.names = TemplateService.supportedProperties
	
	$scope.listFields = ->
		ReportsFactory.query().$promise.then((res)->

			StatisticsService.getCountOfIn($scope.search, res, (collection)->
				$scope.labels = collection[0]
				collection[0].forEach((label)->
					$scope.dataProps.fields[label] = label
				)
			)
			$scope.showData = ->
				StatisticsService.getCountOfIn($scope.search, res, (collection, fieldData, optionLabels)->
					$scope.labels = fieldData[0]
					console.log optionLabels
					if optionLabels.length > 0
						optionLabels.splice(fieldData[0].length, optionLabels.length)
						$scope.labels = optionLabels

					$scope.pie = fieldData[1]
					$scope.line = []
					$scope.line.push fieldData[1]
					if $.inArray($scope.graphtype, ['pie', 'doughnut', 'polar-area'])
						$scope.data = fieldData[1]
					else
						$scope.data = []
						$scope.data.push fieldData[1]

					#angular.element('<div></div>')
					#.data(data)
					#.attr({
					#	id: $scope.graphtype
					#	class: 'chart chart-'+$scope.graphtype
					#	labels: 'labels'
					#})
					#$('<div />', {
					#	id: $scope.graphtype
					#	class: 'chart chart-'+$scope.graphtype
					#	labels: fieldData[0]
					#	data: data
					#	legend: false
					#}).appendTo('#insertCanvas')
				)
			$scope.graphType = (graphtype)->
				$scope.graphtype = graphtype
				if $.inArray(graphtype, ['pie','doughnut','polar-area']) != -1
					$scope.needLegend = true
				else
					$scope.needLegend = false
	)
])