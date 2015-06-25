factories = angular.module('factories')
factories.factory("ReportFactory", ['$auth', '$resource', 'ParseMapService',
($auth, $resource, ParseMapService)->
	return $resource('api/reports/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
		interceptor: {
			response: (response)->
				response.data.sections = ParseMapService.map(response.data.template)
				response.data.participants = ParseMapService.map(response.data.participants)
				return response.data
		}
	})

])
