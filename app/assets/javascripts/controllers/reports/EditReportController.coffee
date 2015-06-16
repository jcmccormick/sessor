controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$scope', '$routeParams', '$location', 'TemplatesFactory', 'ReportFactory',
($rootScope, $scope, $routeParams, $location, TemplatesFactory, ReportFactory)->
	if $routeParams.reportId
		$scope.report = new ReportFactory()
		ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
			jQuery.extend $scope.report, res
			$scope.report.livesave = true
		)
	else
		$scope.report = new ReportFactory()
		$scope.report.livesave = true
		TemplatesFactory.query().$promise.then((res)->
			$scope.templates = res
		)
])