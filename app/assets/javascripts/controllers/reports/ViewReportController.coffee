controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$routeParams', 'ReportsService',
($routeParams, ReportsService)->
	vr = this
	
	ReportsService.getReport($routeParams.reportId).then((res)->
		vr.report = res
		vr.report.viewing = true
		vr.report.livesave = false
		vr.report.editing = false
		vr.report.form = vr.report.templates[0]
	)

	return vr
])