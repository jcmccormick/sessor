controllers = angular.module('controllers')
controllers.controller("NavController", [ '$scope', '$routeParams', '$location'
($scope, $routeParams, $location)->
	$scope.draggable = -> $location.path("/draggable/")
	$scope.goToReports = -> $location.path("/reports/")
	$scope.template  = -> $location.path("/template/")
	$scope.home		 = -> $location.path("/")
	$scope.back      = -> $location.path("/reports")
	$scope.newReport = -> $location.path("/reports/new")
	$scope.clearForm = -> $scope.keywords = []
])