services = angular.module('services')
services.service('DesktopService', ['$auth', 'ClassFactory', 'ReportsService', 'TemplatesService', ($auth, ClassFactory, ReportsService, TemplatesService)->
	{
		getDesktop: ()->
			if !TemplatesService.listTemplates().length
				ClassFactory.get({class: 'desktop_statistics'}, (res)->
					$.extend ReportsService.listReports(), res.reports
					$.extend TemplatesService.listTemplates(), res.templates
				)

		getTemplates: ->
			return TemplatesService.listTemplates()

		getReports: ->
			return ReportsService.listReports()
	}
])