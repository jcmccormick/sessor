controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$routeParams', 'ReportsService',
($routeParams, ReportsService)->
	vm = this
	
	ReportsService.getReport($routeParams.reportId).then((res)->
		vm.report = res
		vm.report.viewing = true
	)

	return vm
])