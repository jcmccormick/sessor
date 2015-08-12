controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$routeParams', 'ReportsService',
($routeParams, ReportsService)->
	vm = this

	if $routeParams.reportId
		ReportsService.getReport($routeParams.reportId).then((res)->
			vm.report = res
			vm.report.livesave = true
			vm.report.hideTitle = false
			vm.report.saveReport = (temp, myForm, report)->	ReportsService.saveReport(temp, myForm, report)
			vm.report.deleteReport = (report)->	ReportsService.deleteReport(report)
			vm.report.getReport = (report)-> ReportsService.getReport(report)
		)
	else
		vm.report = ReportsService.newReport()

	return vm

])