services = angular.module('services')
services.service('DesktopService', ['ClassFactory', (ClassFactory)->

	{

		getDesktop: (dv)->
			ClassFactory.get({class: 'desktop_statistics'}, (res)->
				$.extend dv, res
			)

	}
])