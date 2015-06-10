controllers = angular.module('controllers')
controllers.controller("ReportController",  [ '$scope', '$routeParams', '$resource', '$location', '$localStorage', 'flash', 'ReportFactory',
($scope, $routeParams, $resource, $location, $localStorage, flash, ReportFactory)->
	$scope.$storage = $localStorage
	$scope.reports = ReportFactory.query()

	#store single report data in local storage
	if $routeParams.reportId
		promise = ReportFactory.get({id: $routeParams.reportId}).$promise
		promise.then((res)->
			$scope.report = new ReportFactory()
			$scope.report = res)
		promise.catch((err)-> 
			$location.path("/")
			flash.error = "Sorry, we couldn't find that report."
		)
	else
		$scope.report = new ReportFactory()

	$scope.viewReport = (reportId)-> $location.path("/reports/#{reportId}")
	$scope.editReport = (reportId)-> $location.path("/reports/#{reportId}/edit")

	$scope.saveReport = ->
		if $routeParams.reportId
			$scope.report.$update({id: $routeParams.reportId})
				.then((res)->
					$location.path("/reports/#{$scope.report.id}")
					flash.message = "Report successfully updated.")
				.catch((err)->
					console.log(err.data)
					flash.alert = "There was an error updating. Try again later.")
		else
			$scope.report.$save()
				.then((res)-> 
					console.log(res)
					$scope.report = res
					$scope.reports.push(res)
					flash.message = "Report Created"
					$location.path("/reports/#{$scope.report.id}") 
					)
				.catch((err)->
					flash.alert = "There was an issue creating this report. Try again later.")

	$scope.deleteReport = ()->
		$scope.report.$delete({id: $routeParams.reportId})
			.then((res)->
				$scope.reports.$remove(res)
				$location.path("/reports"))
			.catch((err)->
				flash.alert = "There was an unexpected issue. Try again later.")
				
	$scope.clearForm = -> $scope.keywords = []
	$scope.newReport = -> $location.path("/reports/new")
])