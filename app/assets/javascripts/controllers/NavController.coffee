controllers = angular.module('controllers')
controllers.controller("NavController", [ '$scope', '$routeParams', '$location'
($scope, $routeParams, $location)->
	$scope.goToHome		 = -> $location.path("/")
	$scope.goToReports   = -> $location.path("/reports/")
	$scope.goToTemplates = -> $location.path("/template/")
	$scope.goToDesktop	 = -> $location.path("/desktop/")

])