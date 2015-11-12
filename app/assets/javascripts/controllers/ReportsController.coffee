controllers = angular.module('controllers')
controllers.controller("ReportsController", ['$scope', '$routeParams', 'ReportsService', 'TemplatesService',
($scope, $routeParams, ReportsService, TemplatesService)->

	vr = this

	vr.reports = ReportsService.listReports()
	vr.templates = TemplatesService.listTemplates()
	vr.sortType = 'updated_at'
	vr.sortReverse = true
	vr.currentPage = 0
	vr.pageSize = 10
	setupRep = ->
		vr.report.form = vr.report.templates[0]
		vr.report.e = ReportsService.editing()
	vr.numPages = ->
		return Math.ceil(vr.reports.length/vr.pageSize)

	if repId = parseInt($routeParams.reportId, 10)
		exists = ($.grep vr.reports, (rep)-> rep.id == repId)[0]

		(!exists || (exists && !exists.templates[0].fields)) && ReportsService.queryReport(repId).then((res)->
			vr.report = ReportsService.getReport(repId)
			setupRep()
		)

		exists && exists.templates && exists.templates[0].fields && vr.report = ReportsService.getReport(repId)
		
		vr.report && setupRep()
	else
		vr.report = ReportsService.getReport()

	unbindFormWatch = $scope.$watch (()-> vr.repForm), ((newVal, oldVal)->
		if vr.repForm
			vr.save = (temporary)-> ReportsService.saveReport(temporary, vr.repForm)
			$scope.$on('$locationChangeStart', (event)->
				vr.report.id && !vr.repForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.') && event.preventDefault()
			)
			vr.switchForm = (dir)->
				index = vr.report.templates.indexOf(vr.report.form)
				console.log index
				vr.report.form = vr.report.templates[index+dir]
			unbindFormWatch()
	)

	unbindListWatch = $scope.$watch (()-> vr.filteredList), ((newVal, oldVal)->
		if vr.filteredList
			vr.numPages = ->
				Math.ceil(vr.filteredList.length/vr.pageSize)

			unbindListWatch()
	)


	return vr

])