controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$routeParams', 'ReportsService',
($routeParams, ReportsService)->

	vr = this

	if $routeParams.reportId
		ReportsService.getReport($routeParams.reportId).then((res)->
			vr.report = res
		)
	else
		vr.report = ReportsService.newReport()

	return vr

])