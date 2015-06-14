controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', 'ReportFactory',
($scope, $routeParams, ReportFactory)->
	ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
		$scope.report = res
		jsonData = JSON.parse($scope.report.template)
		$scope.report.sections = $.map(jsonData, (value, index)->
			value.key = index
			return [value]
		)
		$scope.labels = []
		$scope.values = []
		i = 0
		while i < $scope.report.sections.length
			b = 0
			while b < $scope.report.sections[i].columns.length
				c = 0
				while c < $scope.report.sections[i].columns[b].fields.length
					$scope.labels.push $scope.report.sections[i].columns[b].fields[c].type
					$scope.values.push $scope.report.sections[i].columns[b].fields[c].value
					c++
				b++
			i++
		console.log $scope.labels
		console.log $scope.values
	)
])