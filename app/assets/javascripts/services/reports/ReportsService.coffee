services = angular.module('services')
services.service('ReportsService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
	
	associateReportValues = (report)->
		deferred = $q.defer()
		report.template_ids = []
		report.templates.forEach((template)->
			report.template_ids.push template.id
			template.fields.forEach((field)->
				field.values = report.values.filter((obj)->
					return obj.field_id == field.id
				)
			)
		)
		deferred.resolve(report)
		return deferred.promise
	
	validateReport = (report, errors)->
		deferred = $q.defer()
		errors = ''
		required = ''
		if report.templates
			for template in report.templates
				for field in template.fields
					if field.required
						if !field.values[0].input?
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

		newReport: ->
			report = new ClassFactory()
			report.livesave = true
			report.template_ids = []
			report.hideTitle = false
			report.saveReport = this.saveReport
			return report

		getReport: (id)->
			deferred = $q.defer()
			ClassFactory.get({class: 'reports', id: id}, (res)->
				associateReportValues(res).then((rep)->
					deferred.resolve(rep)
				)
			)
			return deferred.promise

		deleteReport: (report)->
			report.$delete({class: 'reports', id: report.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)
			return

		saveReport: (temp, myForm, report)->
			deferred = $q.defer()
			validateReport(report).then((errors)->
				if !!errors 
					Flash.create('danger', errors)
					deferred.resolve(errors)
					return

				if !report.id
					report.$save({class: 'reports'}, (res)->
						associateReportValues(res).then((res)->
							$location.path("/reports/#{res.id}/edit")
							Flash.create('success', '<p>New report created!</p>')
						)
					)
				else
					if myForm.$dirty
						report.values_attributes = report.values
						$rootScope.$broadcast('clearreports')
						report.$update({class: 'reports', id: report.id}, (res)->
							Flash.create('success', '<p>Report saved!</p>')
							myForm.$setPristine()
							report.getReport(res.id).then((rep)->
								deferred.resolve(rep)
								if temp != true then $location.path("/reports/#{report.id}")
							)
						)

					else if !temp
						deferred.resolve($location.path("/reports/#{report.id}"))
					else
						deferred.resolve(Flash.create('info', '<p>Report unchanged.</p>'))

			)
			return deferred.promise

	}
])