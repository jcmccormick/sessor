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
					report.values_attributes.push field.values[0]
					if field.required && !field.values[0].input?
						required += '<li>'+template.name+': '+field.name+'</li>'

		if !!required
			errors += 'The following fields are required<ul>'+required+'</ul>'

		if report.allow_title && !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test report.title
			errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'
		else if !report.title
			report.title = 'Untitled'

		deferred.resolve(errors)
		return deferred.promise

	{

		setBreadcrumb: (template, report)->
			report.form = template

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
			report.setBreadcrumb = this.setBreadcrumb
			report.getReport = this.getReport
			report.saveReport = this.saveReport
			report.deleteReport = this.deleteReport
			report.addTemplate = this.addTemplate
			report.removeTemplate = this.removeTemplate
			report.getTemplates = this.getTemplates

			ClassFactory.get({class: 'reports', id: id}, (res)->
				$.extend report, res

				sorting = []
				angular.copy res.template_order, sorting
				res.templates = res.templates.map((item) ->
					n = sorting.indexOf(item.id)
					sorting[n] = ''
					[n, item]
				).sort().map((j) ->	j[1])

				report.form = report.templates[0]
				
				report.getTemplates(report).then((res)->
					report.add_templates = res.add_templates
					deferred.resolve(report)
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

				if !repCopy.id
					repCopy.$save({class: 'reports'}, (res)->
						$location.path("/reports/#{res.id}/edit")
						Flash.create('success', '<p>Report saved!</p>', 'customAlert')
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