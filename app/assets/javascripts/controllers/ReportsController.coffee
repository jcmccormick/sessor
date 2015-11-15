controllers = angular.module('controllers')
controllers.controller("ReportsController", ['$scope', '$routeParams', 'ReportsService', 'TemplatesService',
($scope, $routeParams, ReportsService, TemplatesService)->

	vr = this

	vr.templates = TemplatesService.listTemplates()
	vr.reports = ReportsService.listReports()

	if $routeParams.reportId || ReportsService.creating()
		if ReportsService.creating()
			vr.report = ReportsService.extendReport()
		else
			vr.report = ReportsService.extendReport(parseInt($routeParams.reportId, 10))
			vr.report = ReportsService.sortTemplates(vr.report)

			for template in vr.report.templates
				template.e = false
				(!template.sections || (moment(template.updated_at).format('X') > moment(vr.report.updated_at).format('X'))) && reload = true

			reload && ReportsService.queryReport(vr.report.id, true).then((res)->
				$.extend vr.report, res
				vr.report.form = vr.report.templates[0]
			)

			vr.report.form = vr.report.templates[0]

		vr.addTemplate = ->
			vr.report.template_order.push vr.template.id
			ReportsService.addTemplate(vr.report, vr.repForm)
			vr.template = vr.filteredTemplates()[0]
		vr.filteredTemplates = ->
			vr.templates.filter((template)->
				!template.draft && vr.report.template_order.indexOf(template.id) == -1
			)

		vr.template = vr.filteredTemplates()[0]
				
		vr.switchForm = (dir)->
			index = $.map(vr.report.templates, (x)-> x.id).indexOf(vr.report.form.id)
			vr.report.form = vr.report.templates[index+dir]

		if vr.report.e = ReportsService.editing()

			$scope.$on('$locationChangeStart', (event)->
				!vr.repForm.$pristine && !confirm('There are unsaved changes. Press cancel to return to the form.') && event.preventDefault()
			)

			vr.save = (temporary)->
				ReportsService.saveReport(vr.report, temporary, vr.repForm)

			vr.deleteTemplate = ->
				delId = parseInt(vr.report.form.id, 10)
				index = vr.report.template_order.indexOf(delId)
				vr.report.template_order.splice index, 1
				vr.report.templates.splice index, 1

				vr.report.did = delId

				vr.repForm.$pristine = false
				vr.save(true).then((res)->
					vr.report.did = undefined
					vr.template = vr.filteredTemplates()[0]
					vr.report.form = vr.report.templates[0]
				)
	else
		vr.sortType = 'id'
		vr.sortReverse = true
		vr.currentPage = 0
		vr.pageSize = 10
		vr.numPages = ->
			Math.ceil(vr.filteredList.length/vr.pageSize)

	vr.delete = (report)->
		ReportsService.deleteReport(report, vr.repForm)



	return vr

])