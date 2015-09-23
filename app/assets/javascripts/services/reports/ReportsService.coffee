services = angular.module('services')
services.service('ReportsService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
	
	validateReport = (report)->
		deferred = $q.defer()
		errors = ''
		required = ''
		report.values_attributes = []
		if report.templates
			for template in report.templates
				for field in template.fields
					report.values_attributes.push field.value
					if field.required && !field.value.input?
						required += '<li>'+template.name+': '+field.name+'</li>'
					if !field.options.length
						field.options = undefined

		if !!required
			errors += 'The following fields are required<ul>'+required+'</ul>'

		if report.allow_title && !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test report.title
			errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'
		else if !report.title
			report.title = 'Untitled'

		deferred.resolve(errors)
		return deferred.promise

	sortTemplates = (reports)->
		deferred = $q.defer()

		if reports.length == undefined
			reports = [reports]
			return_one = true

		for report in reports
			sorted = []
			for key in report.template_order
				found = false
				report.templates = report.templates.filter((template)->
					if !found && template.id == key
						sorted.push template
						found = true
						return false
					else
						return true
				)

			report.templates = sorted

		if return_one
			deferred.resolve(reports[0])
		else
			deferred.resolve(reports)

		return deferred.promise

	{

		newReport: ->
			report = new ClassFactory()
			report.livesave = true
			report.hideTitle = false
			report.template_order = []
			report.addTemplate = this.addTemplate
			report.saveReport = this.saveReport
			this.getTemplates(report).then((res)-> report = res)
			return report

		getReport: (id)->
			deferred = $q.defer()
			report = new ClassFactory()
			report.livesave = true
			report.editing = true
			report.hideTitle = false
			report.getReport = this.getReport
			report.saveReport = this.saveReport
			report.deleteReport = this.deleteReport
			report.addTemplate = this.addTemplate
			report.removeTemplate = this.removeTemplate
			report.getTemplates = this.getTemplates

			ClassFactory.get({class: 'reports', id: id}, (res)->

				$.extend report, res
				sortTemplates(report).then((rep)->
					if $location.path().indexOf('edit') != -1
						rep.getTemplates(rep).then((rez)->
							rep.add_templates = rez.add_templates
							deferred.resolve(rep)
						)
					else
						deferred.resolve(rep)
				)				
			)
			return deferred.promise

		saveReport: (temp, myForm, report)->
			deferred = $q.defer()
			validateReport(report).then((errors)->
				if !!errors 
					Flash.create('danger', errors, 'customAlert')
					deferred.resolve(errors)
					return

				repCopy = new ClassFactory()
				$.extend repCopy, report
				repCopy.add_templates = undefined

				if !repCopy.id
					repCopy.$save({class: 'reports'}, (res)->
						Flash.create('success', '<p>Report saved!</p>', 'customAlert')
						$location.path("/reports/#{res.id}/edit")
					)
				else if myForm.$dirty
					repCopy.$update({class: 'reports', id: repCopy.id}, (res)->
						Flash.create('success', '<p>Report updated!</p>', 'customAlert')
						$rootScope.$broadcast('clearreports')
						myForm.$setPristine()
						deferred.resolve('updated')
						if !temp then $location.path("/reports/#{res.id}")
					)
				else
					Flash.create('info', '<p>Report unchanged.</p>', 'customAlert')
					if !temp
						deferred.resolve($location.path("/reports/#{report.id}"))
					else
						deferred.resolve()

			)
			return deferred.promise

		deleteReport: (report)->
			report.$delete({class: 'reports', id: report.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)
			return

		newView: (view)->
			view.reports = []
			view.page = 1
			view.getReports = this.getReports
			view.searchReports = this.searchReports
			return view

		getReports: (view)->
			deferred = $q.defer()
			if view.keywords && view.page == 1
				view.reports = []
			ClassFactory.query({class: 'reports', page: view.page, keywords: view.keywords}, (reports)->
				sortTemplates(reports).then((reps)->
					view.page++
					view.reports = view.reports.concat(reps)
					deferred.resolve(view)
				)
			)
			return deferred.promise

		searchReports: (view)->
			view.reports = []
			view.page = 1
			this.getReports(view)
			return

		getTemplates: (report)->
			deferred = $q.defer()
			ClassFactory.query({class: 'templates', ts: [report.template_order]}, (templates)->
				report.add_templates = templates
				deferred.resolve(report)
			)
			return deferred.promise

		addTemplate: (template, myForm, report)->
			deferred = $q.defer()
			myForm.$dirty = true
			report.template_order.push template.id
			report.saveReport(true, myForm, report).then((res)->
				if res == 'updated'
					report.getReport(report.id).then((rep)->
						templateindex = report.add_templates.indexOf(template)
						report.add_templates.splice templateindex, 1
						report.templates.push rep.templates[rep.templates.length-1]
						report.form = rep.templates[rep.templates.length-1]
						deferred.resolve(report)
					)
				else
					report.template_order.pop()
			)
			return deferred.promise

		removeTemplate: (template, report)->
			deferred = $q.defer()
			templateindex = report.templates.indexOf(template)
			orderindex = report.template_order.indexOf(template.id)
			report.templates.splice templateindex, 1
			report.template_order.splice orderindex, 1
			report.add_templates.push template
			report.form = if templateindex==0 then report.templates[0] else report.templates[templateindex-1]
			report.$update({class: 'reports', id: report.id, did: template.id}, ->
				Flash.create('success', '<p>'+template.name+' has been removed from the report.</p>', 'customAlert')
				$rootScope.$broadcast('clearreports')
				deferred.resolve(report)
			)
			return deferred.promise

	}
])