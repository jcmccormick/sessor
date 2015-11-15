services = angular.module('services')
services.service('ReportsService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash', 'TemplatesService',
($interval, $location, $q, $rootScope, ClassFactory, Flash, TemplatesService)->
	
	reports = []

	validateReport = (report)->
		required = ''
		report.errors = ''
		report.values_attributes = []
		for template in report.templates
			template.fields && for field in template.fields
				field.fieldtype != 'labelntext' && report.values_attributes.push field.value
				field.o.required && !field.value.input? && required += '<li><strong>'+template.name+'</strong>: '+field.o.name+'</li>'

		!!required && report.errors += '<h3>Required Fields</h3> <ul class="list-unstyled">'+required+'</ul>'

		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(report.title) && report.errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'
		!report.title && report.title = 'Untitled'

		return report

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true
		creating: ->
			return if $location.path().search('/new') == -1 then false else true

		listReports: ->
			deferred = $q.defer()
			if reports.length
				return reports
			else
				rs = this
				ClassFactory.query({class: 'reports'}, (res)->
					$.extend reports, res
					for report in reports
						report = rs.sortTemplates(report)
					deferred.resolve(reports)
				)
			return deferred.promise

		queryReport: (id, refreshing)->
			deferred = $q.defer()
			exists = $.map(reports, (x)-> x.id).indexOf(id)
			if !reports[exists].loadedFromDB || refreshing
				ClassFactory.get({class: 'reports', id: id}, (res)->
					res.loadedFromDB = true
					deferred.resolve(res)
				)
			else
				deferred.resolve(report[exists])
			return deferred.promise

		extendReport: (id)->
			exists = $.map(reports, (x)-> x.id).indexOf(id)
			report = $.extend (reports[exists] || {title: 'Untitled', templates: [], template_order: []}), new ClassFactory()
			return report

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

			console.log report

			if !report.id
				report.$save({class: 'reports'}, (res)->
					index = reports.push res
					$location.path("/reports/#{res.id}/edit")
					deferred.resolve(reports[index])
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
					report.$update({class: 'reports', id: report.id}, (res)->
						form.$setPristine()
						deferred.resolve(res)
						!temporary && $location.path("/reports/#{report.id}")
					)
				else
					!temporary && $location.path("/reports/#{report.id}")

			return deferred.promise

		deleteReport: (report)->
			index = $.map(reports, (x)-> x.id).indexOf(report.id)
			reports.splice(index, 1)
			report.$delete({class: 'reports', id: report.id}, ((res)->
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
				report.e && rs.queryReport(report.id, true).then((rep)->
					$.extend report, rs.sortTemplates(rep)
					report.form = report.templates[report.templates.length-1]
				)
			), (err)->
				report.template_order.pop()
			return

		sortTemplates: (report)->
			sorted = []
			for key in report.template_order
				found = false
				TemplatesService.getTemplates().filter (template)->
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
				angular.extend output[template], report.templates[template], true

			report.templates = output
			report.form = report.templates[0]
			return report
	}
])