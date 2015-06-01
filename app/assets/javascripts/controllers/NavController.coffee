controllers = angular.module('controllers')
controllers.controller("NavController", [ '$scope', '$routeParams', '$location'
($scope, $routeParams, $location)->
	$scope.goToDraggable = -> $location.path("/draggable/")
	$scope.goToReports   = -> $location.path("/reports/")
	$scope.goToTemplate  = -> $location.path("/template/")
	$scope.goToHome		 = -> $location.path("/")
])