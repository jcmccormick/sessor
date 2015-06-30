controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$auth', '$scope', '$routeParams', '$location', 'TemplatesFactory', 'ReportFactory',
($rootScope, $auth, $scope, $routeParams, $location, TemplatesFactory, ReportFactory)->

	$scope.report = new ReportFactory()
	$scope.report.livesave = true

	if $routeParams.reportId
		ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
			jQuery.extend $scope.report, res
		)
	else
		TemplatesFactory.query().$promise.then((res)->
			$scope.templates = res
		)
])