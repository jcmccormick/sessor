services = angular.module('services')
services.service('ReportsService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash', 'localStorageService', 'TemplatesService',
($interval, $location, $q, $rootScope, ClassFactory, Flash, localStorageService, TemplatesService)->
	
	reports = localStorageService.get('_csr')
	slr = ->
		localStorageService.set('_csr', reports)
	geti = (id)->
		$.map(reports, (x)-> x.id).indexOf(id)

	validateReport = (report)->
		required = ''
		report.errors = ''
		report.values_attributes = []
		for template in report.templates
			template.fields && for field in template.fields
				field.fieldtype != 'labelntext' && report.values_attributes.push field.value
				field.value && field.o.required && !field.value.input? && required += '<li><strong>'+template.name+'</strong>: '+field.o.name+'</li>'

		!!required && report.errors += '<h3>Required Fields</h3> <ul class="list-unstyled">'+required+'</ul>'

		return report

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true

		creating: ->
			return if $location.path().search('/new') == -1 then false else true

		getReports: ->
			return reports

		listReports: ->
			deferred = $q.defer()
			rs = this
			ClassFactory.query({class: 'reports'}, (res)->
				$.extend reports, res
				for report in reports
					report = rs.sortTemplates(report)
				slr(reports)
				deferred.resolve(reports)
			)
			return deferred.promise

		queryReport: (id, refreshing)->
			deferred = $q.defer()
			if !reports[geti(parseInt(id, 10))].loadedFromDB || refreshing
				ClassFactory.get({class: 'reports', id: id}, (res)->
					res.loadedFromDB = true
					reports[geti(parseInt(id, 10))] = res
					slr(reports)
					deferred.resolve(res)
				)
			else
				deferred.resolve(report[exists])
			return deferred.promise

		extendReport: (id)->
			return $.extend (reports[geti(parseInt(id, 10))] || {title: 'Untitled', templates: [], template_order: []}), new ClassFactory()

		# save/update report
		saveReport: (report, temporary, form)->
			rs = this
			deferred = $q.defer()
			validateReport(report)
			if !!report.errors
				Flash.create('danger', report.errors, 'customAlert')
				report.errors = ''
				deferred.reject()
				return deferred.promise

			if !report.id
				report.$save({class: 'reports'}, (res)->
					reports.push res
					slr(reports)
					$location.path("/reports/#{res.id}/edit")
					return deferred.resolve(res)
				)
			else
			
				!timedSave && timedSave = $interval (->
					report.id && !form.$pristine && rs.saveReport(report, true, form)
				), 30000

				!dereg && dereg = $rootScope.$on('$locationChangeSuccess', ()->
					$interval.cancel(timedSave)
					dereg()
				)
				if !form.$pristine
					reports[geti(report.id)] = report
					slr(reports)
					report.$update({class: 'reports', id: report.id}, (res)->
						form.$setPristine()
						deferred.resolve(res)
						!temporary && $location.path("/reports/#{report.id}")
					)
				else
					!temporary && $location.path("/reports/#{report.id}")

			return deferred.promise

		deleteReport: (report)->
			$.extend report, new ClassFactory()
			report.$delete({class: 'reports', id: report.id}, ((res)->
				reports.splice(geti(report.id), 1)
				slr(reports)
				$location.path("/reports")
			), (err)->
				Flash.create('danger', '<p>'+err.data.errors+'</p>', 'customAlert')
			)
			return

		addTemplate: (report, form)->
			rs = this
			form.$pristine = false
			!report.id && $.extend report, new ClassFactory()
			rs.saveReport(report, true, form).then ((res)->
				TemplatesService.queryTemplate(report.template_order[report.template_order.length-1], true).then((res)->
					report.e && rs.queryReport(report.id, true).then((res)->
						res = rs.sortTemplates(res)
						reports[geti(report.id)] = res
						slr(reports)
						$.extend report, reports[geti(report.id)]
						report.form = report.templates[report.templates.length-1]
					)
				)
			), (err)->
				report.template_order.pop()

			return

		sortTemplates: (report)->
			sorted = []
			for key in report.template_order
				found = false
				localStorageService.get('_cst').filter (template)->
					if !found && template.id == key
						sorted.push template
						found = true
						return false
					else
						return true

			output = []

			for template of sorted
				output[template] = sorted[template]

			for template of report.templates
				report.templates[template].e = false
				if report.template_order.indexOf(report.templates[template].id) != -1
					$.extend true, output[template], report.templates[template]

			report.templates = output
			report.form = report.templates[0]

			return report
	}
])