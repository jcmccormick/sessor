services = angular.module('services')
services.service('ReportsService', ['$interval', '$location', '$q', '$rootScope', 'ClassFactory', 'Flash',
($interval, $location, $q, $rootScope, ClassFactory, Flash)->
	
	reports = []

	validateReport = (report)->
		deferred = $q.defer()

		# prepare a copy of the template for sending to the DB
		# sending only the necessary data back
		tempCopy = new ClassFactory()
		angular.copy {
			id: report.id
			title: report.title
			template_order: report.template_order
			values_attributes: []
			errors: ''
		}, tempCopy

		required = ''

		console.log report.templates

		report.templates.length && for template in report.templates
			template && template.fields.length && for field in template.fields
				tempCopy.values_attributes.push field.value
				field.required && !field.value.input? && required += '<li>'+template.name+': '+field.name+'</li>'

		!!required && tempCopy.errors += 'The following fields are required<ul>'+required+'</ul>'

		!tempCopy.title && tempCopy.title = 'Untitled'
		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(tempCopy.title) && tempCopy.errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'

		deferred.resolve(tempCopy)

		return deferred.promise

	sortTemplates = (report)->
		sorted = []
		if report.templates.length
			console.log 'what'
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
		return

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true

		listReports: ->
			return reports

		getReport: (id)->
			if !id
				delete this.id
				delete this.name
				delete this.templates
				delete this.template_order
			report = ($.grep reports, (rep)-> rep.id == id)[0]
			report = $.extend this, report
			report.templates && sortTemplates(report)
			return report

		queryReport: (id)->
			deferred = $q.defer()
			ClassFactory.get({class: 'reports', id: id}, (res)->
				if rep = ($.grep reports, (report)-> report.id == id)[0]
					$.extend rep, res
				else
					reports.push(res)
				deferred.resolve()
			)
			return deferred.promise

		# save/update report
		saveReport: (temporary, form)->
			# Auto-save
			!timedSave && timedSave = $interval (->
				this.id && !form.$pristine && this.saveReport(true, form)
			), 30000

			!dereg && dereg = $rootScope.$on('$locationChangeSuccess', ()->
				$interval.cancel(timedSave)
				dereg()
			)

			# validate and save
			validateReport(this).then((report)->
				if !!report.errors
					Flash.create('danger', report.errors, 'customAlert')
					return

				!report.id && report.$save({class: 'reports'}, (res)->
					reports.push res
					$location.path("/reports/#{res.id}/edit")
				)

				if report.id
					!form.$pristine && report.$update({class: 'reports', id: report.id}, (res)->
						res.updated_at = moment().local().format()
						$.extend ($.grep reports, (repo)-> repo.id == res.id)[0], res
						!temporary && $location.path("/reports/#{res.id}")
						form.$setPristine()
					)
					form.$pristine && !temporary && $location.path("/reports/#{report.id}")

				$rootScope.$broadcast('clearreports')				
			)
			return

		deleteReport: (form)->
			index = reports.indexOf ($.grep reports, (report)-> report.id == this.id)[0]
			reports.splice(index, 1)
			this.$delete({class: 'reports', id: this.id}, ((res)->
				form.$setPristine()
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			), (err)->
				Flash.create('danger', '<p>'+err.data.errors+'</p>', 'customAlert')
			)
			return

		addTemplate: (template, form)->
			!this.templates && this.templates = []
			!this.template_order && this.template_order = []
			this.template_order.push template.id
			if template.fields
				this.form = template
				this.templates.push this.form
				this.saveReport(true, form)
			else
				ts = this
				ClassFactory.get({class: 'templates', id: template.id}, (res)->
					ts.form = res
					ts.templates.push ts.form
					ts.saveReport(true, form)
				)
			return

		removeTemplate: (template)->
			deferred = $q.defer()
			templateindex = this.templates.indexOf(template)
			orderindex = this.template_order.indexOf(template.id)
			this.templates.splice templateindex, 1
			this.template_order.splice orderindex, 1
			this.form = if templateindex==0 then this.templates[0] else this.templates[templateindex-1]
			this.$update({class: 'reports', id: this.id, did: template.id}, ->
				Flash.create('success', '<p>'+template.name+' has been removed from the report.</p>', 'customAlert')
				$rootScope.$broadcast('clearreports')
			)

	}
])