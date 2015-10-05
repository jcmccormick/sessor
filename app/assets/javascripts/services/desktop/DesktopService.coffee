services = angular.module('services')
services.service('DesktopService', ['ClassFactory', (ClassFactory)->
	
	#validateReport = (report)->
	#	deferred = $q.defer()

	{

		getDesktop: (dv)->
			ClassFactory.get({class: 'desktop_statistics'}, (res)->
				$.extend dv, res
			)

	}
])