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

		for template in report.templates
			template && template.fields.length && for field in template.fields
				tempCopy.values_attributes.push field.value
				field.o.required && !field.value.input? && required += '<li><strong>'+template.name+'</strong>: '+field.o.name+'</li>'

		!!required && tempCopy.errors += '<h3>Required Fields</h3> <ul class="list-unstyled">'+required+'</ul>'

		!tempCopy.title && tempCopy.title = 'Untitled'
		!/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test(tempCopy.title) && tempCopy.errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'

		deferred.resolve(tempCopy)

		return deferred.promise

	sortTemplates = (report)->
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
		report.form = report.templates[report.templates.length-1]
		return

	{
		editing: ->
			return if $location.path().search('/edit') == -1 then false else true

		listReports: ->
			!reports.length && this.getReports()
			return reports

		getReports: ->
			ClassFactory.query({class: 'reports'}, (res)-> $.extend reports, res)
			return

		getReport: (id)->
			if !id
				delete this.id
				this.title = 'Untitled'
				this.templates = []
				this.template_order = []
				this.form = undefined
			if report = ($.grep reports, (rep)-> rep.id == id)[0]
				sortTemplates(report)
			report = $.extend this, report
			return report

		queryReport: (id)->
			deferred = $q.defer()
			ClassFactory.get({class: 'reports', id: id}, (res)->
				if report = ($.grep reports, (rep)-> rep.id == id)[0]
					$.extend report, res
				else
					reports.push(res)
				deferred.resolve(report || res)
			)
			return deferred.promise

		# save/update report
		saveReport: (temporary, form)->
			deferred = $q.defer()
			# Auto-save
			if this.id
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
					deferred.reject(report.errors)
					return

				!report.id && report.$save({class: 'reports'}, (res)->
					reports.push res
					deferred.resolve(res)
					$location.path("/reports/#{res.id}/edit")
				)

				if report.id && form
					!form.$pristine && report.$update({class: 'reports', id: report.id}, (res)->
						deferred.resolve(res)
						res.updated_at = moment().local().format()
						$.extend ($.grep reports, (repo)-> repo.id == res.id)[0], res
						!temporary && $location.path("/reports/#{res.id}")
						form.$setPristine()
					)
					form.$pristine && !temporary && $location.path("/reports/#{report.id}")

				$rootScope.$broadcast('clearreports')				
			)
			return deferred.promise

		deleteReport: (form)->
			$.extend this, new ClassFactory()
			this.$delete({class: 'reports', id: this.id}, ((res)->
				index = reports.indexOf ($.grep reports, (report)->	res.id == report.id)[0]
				reports.splice(index, 1)
				form.$setPristine()
				$location.path("/reports")
			), (err)->
				Flash.create('danger', '<p>'+err.data.errors+'</p>', 'customAlert')
			)
			return

		addTemplate: (template, form)->
			if template.draft
				Flash.create('success', '<p>Please turn off the <strong>draft</strong> setting for '+template.name+' to use it in a report.</p>', 'customAlert')
			else
				!this.templates && this.templates = []
				!this.template_order && this.template_order = []
				this.template_order.push template.id
				ts = this
				this.saveReport(true, form).then ((res)->
					ts.queryReport(res.id).then((res)->
						ts.getReport(res.id)
					)
				), ->
					ts.template_order.pop()
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