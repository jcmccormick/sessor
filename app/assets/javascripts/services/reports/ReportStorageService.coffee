services = angular.module('services')
services.service("ReportsStorageService", ['$cacheFactory',
($cacheFactory)->
	reports = []
	reports.report
	service = {
		saveState: ->
			#localStorageService.set('reports', angular.toJson(service.report))
			return
		restoreState: ->
			service.report = angular.fromJson(localStorageService.get('reports'))
			return
	}

	$rootScope.$on("savestate", service.saveState)
	$rootScope.$on("restorestate", service.restoreState)


	
	updateReports = ->
		ReportsFactory.query().$promise
		.then((res)->
			reports = res
		)
	updateReports()


	reports:
		report:
			participants: ''
			name: ''
			submission: ''
			response: ''
			active: ''
			location: ''


	$rootScope.$on("savestate", service.saveState)
	$rootScope.$on("restorestate", service.restoreState)
])