services = angular.module('services')
services.service('ReportsService', ['$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($location, $q, $rootScope, ClassFactory, Flash)->
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
				res.template_ids = []
				res.templates.forEach((template)->
					res.template_ids.push template.id
					template.fields.forEach((field)->
						field.values = res.values.filter((obj)->
							return obj.field_id == field.id
						)
					)
				)
				deferred.resolve(res)
			)
			return deferred.promise

		deleteReport: (report)->
			report.$delete({class: 'reports', id: report.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)

		saveReport: (temp, myForm, report)->
			deferred = $q.defer()
			errors = ''
			required = ''

			if report.templates.length
				for template in report.templates
					for field in template.fields
						if field.required
							if !field.values[0].input? then required += '<li>'+template.name+': '+field.name+'</li>'

			if !report.title then report.title = 'Untitled'
			if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test report.title
				errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'
			if !!required then errors += 'The following fields are required<ul>'+required+'</ul>'
			if !!errors then Flash.create('danger', errors)

			else
				if !report.id
					report.$save({class: 'reports'}, (res)->
						$location.path("/reports/#{res.id}/edit")
						Flash.create('success', '<p>New report created!</p>')
					)
				else
					report.values_attributes = report.values
					report.$update({class: 'reports', id: report.id}, (res)->
						deferred.resolve(res)
						$rootScope.$broadcast('clearreports')
						Flash.create('success', '<p>Report saved!</p>')
						myForm.$setPristine()
						if temp != true then $location.path("/reports/#{report.id}")
					)

			return deferred.promise
	}
])