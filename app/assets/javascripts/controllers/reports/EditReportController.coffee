controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$routeParams', 'ReportsService',
($routeParams, ReportsService)->
	vr = this

	# check for report id and get report or prepare a new report object
	if $routeParams.reportId
		ReportsService.getReport($routeParams.reportId).then((res)->
			vr.report = res
			vr.report.livesave = true
			vr.report.editing = true
			vr.report.hideTitle = false
			vr.report.saveReport = (temp, myForm, report)->	ReportsService.saveReport(temp, myForm, report)
			vr.report.deleteReport = (report)->	ReportsService.deleteReport(report)
			vr.report.getReport = (report)-> ReportsService.getReport(report)
		)
	else
		vr.report = ReportsService.newReport()

	return vr

])