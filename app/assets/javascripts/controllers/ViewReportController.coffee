controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', 'TemplateService',
($scope, $routeParams, TemplateService) ->
	$scope.form = {}
	# read form with given id
	TemplateService.form($routeParams.id).then (form) ->
		$scope.form = form
		return
	return
])