controllers = angular.module('controllers')
controllers.controller("ReportController",  [ '$scope', '$routeParams', '$resource', '$location', '$localStorage', 'flash', 'ReportFactory',
($scope, $routeParams, $resource, $location, $localStorage, flash, ReportFactory)->
	$scope.$storage = $localStorage
	$scope.reports = []
	$scope.report = []
	$scope.$storage.reports = $scope.reports
	$scope.$storage.report = $scope.report

	if $routeParams.reportId
		promise = ReportFactory.get({id: $routeParams.reportId}).$promise
		promise.then((res)->
			$scope.report = res)
		promise.catch((err)-> 
			$location.path("/")
			flash.error = "Sorry, we couldn't find that report."
		)
	else
		$scope.report = new ReportFactory()

	$scope.reports = ReportFactory.query()


	$scope.viewReport = (reportId)-> $location.path("/reports/#{reportId}")
	$scope.editReport = (reportId)-> $location.path("/reports/#{reportId}/edit")

	$scope.saveReport = ->
		if $routeParams.reportId
			$scope.report.$update({id: $routeParams.reportId})
				.then((res)-> 
					$location.path("/reports/#{$scope.report.id}")
					flash.message = "Report successfully updated.")
				.catch((err)->
					flash.alert = "There was an error updating. Try again later.")
		else
			$scope.report.$save()
				.then((res)-> 
					$location.path("/reports/#{$scope.report.id}") 
					flash.message = "Report Updated")
				.catch((err)->
					flash.alert = "There was an issue creating this report. Try again later.")

	$scope.deleteReport = ()->
		$scope.report.$delete({id: $routeParams.reportId})
			.then((res)->
				$location.path("/reports")
				delete $scope.$storage.report)
			.catch((err)->
				flash.alert = "There was an unexpected issue. Try again later.")
				
	$scope.clearForm = -> $scope.keywords = []
	$scope.newReport = -> $location.path("/reports/new")
])