controllers = angular.module('controllers')
controllers.controller("ShowReportsController",  ['ReportsService',
(ReportsService)->

	vrs = this

	ReportsService.newView(vrs)

	return vrs
])