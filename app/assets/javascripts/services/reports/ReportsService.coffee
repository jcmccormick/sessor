services = angular.module('services')
services.service('ReportsService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
	
	validateReport = (report)->
		deferred = $q.defer()
		errors = ''
		required = ''
		if report.templates
			for template in report.templates
				for field in template.fields
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

		newReport: ->
			report = new ClassFactory()
			report.saveReport = this.saveReport
			report.livesave = true
			report.hideTitle = false
			report.template_ids = []
			return report

		deleteReport: (report)->
			report.$delete({class: 'reports', id: report.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)
			return

		getReport: (id)->
			deferred = $q.defer()
			ClassFactory.get({class: 'reports', id: id}, (res)->
				res.hideTitle = false
				res.template_ids = []
				for template in res.templates
					res.template_ids.push template.id
				deferred.resolve(res)
			)
			return deferred.promise

		saveReport: (temp, myForm, report)->
			deferred = $q.defer()
			validateReport(report).then((errors)->
				if !!errors 
					Flash.create('danger', errors, 'customAlert')
					deferred.resolve(errors)
					return

				if !report.id
					report.$save({class: 'reports'}, (res)->
						$location.path("/reports/#{res.id}/edit")
						Flash.create('success', '<p>Report saved!</p>', 'customAlert')
					)
				else
					if myForm.$dirty
						report.values_attributes = []
						for template in report.templates
							for field in template.fields
								report.values_attributes.push field.values[0]
						$rootScope.$broadcast('clearreports')
						report.$update({class: 'reports', id: report.id}, ->
							Flash.create('success', '<p>Report updated!</p>', 'customAlert')
							myForm.$setPristine()
							report.getReport(report.id).then((res)->
								$.extend report, res
								deferred.resolve(report)
								if temp != true then $location.path("/reports/#{report.id}")
							)
						)

					else if !temp
						deferred.resolve($location.path("/reports/#{report.id}"))
					else
						deferred.resolve(Flash.create('info', '<p>Report unchanged.</p>', 'customAlert'))

			)
			return deferred.promise

	}
])