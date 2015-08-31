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

		newReport: ->
			report = new ClassFactory()
			report.saveReport = this.saveReport
			report.livesave = true
			report.hideTitle = false
			report.template_order = []
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

				repCopy = new ClassFactory()
				$.extend repCopy, report

				if !repCopy.id
					repCopy.$save({class: 'reports'}, (res)->
						$location.path("/reports/#{res.id}/edit")
						Flash.create('success', '<p>Report saved!</p>', 'customAlert')
					)
				else if myForm.$dirty
					repCopy.values_attributes = []
					for template in repCopy.templates
						for field in template.fields
							repCopy.values_attributes.push field.values[0]
					repCopy.$update({class: 'reports', id: repCopy.id}, ->
						$rootScope.$broadcast('clearreports')
						Flash.create('success', '<p>Report updated!</p>', 'customAlert')
						myForm.$setPristine()
						deferred.resolve('updated')
						if temp != true then $location.path("/reports/#{report.id}")
					)

				else
					Flash.create('info', '<p>Report unchanged.</p>', 'customAlert')
					if !temp
						deferred.resolve($location.path("/reports/#{report.id}"))
					else
						deferred.resolve()

			)
			return deferred.promise

		removeTemplate: (template, report)->
			deferred = $q.defer()
			report.$update({class: 'reports', id: report.id, did: template.id}, ->
				$rootScope.$broadcast('clearreports')
				deferred.resolve('deleted')
			)
			return deferred.promise


	}
])