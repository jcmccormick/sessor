controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$auth', '$scope', '$routeParams', '$location', 'TemplatesFactory', 'ReportFactory',
($rootScope, $auth, $scope, $routeParams, $location, TemplatesFactory, ReportFactory)->
	$scope.report = new ReportFactory()
	if $routeParams.reportId
		ReportFactory.get({id: $routeParams.reportId}).$promise.then((res)->
			jQuery.extend $scope.report, res
			console.log $scope.report.participants
			if $.inArray($auth.user.uid, $scope.report.participants) == -1
				$scope.report.participants.push $auth.user.uid
			$scope.report.livesave = true
		)
	else
		TemplatesFactory.query().$promise.then((res)->
			$scope.templates = res
		)

		$scope.selectTemplate = ->
			$scope.report.livesave = true
			$scope.report.sections = $scope.selectedTemplate.sections
			$scope.report.template_id = $scope.selectedTemplate.id
			$scope.report.template_name = $scope.selectedTemplate.name
			$scope.report.participants = []
			$scope.report.participants.push $auth.user.uid
])