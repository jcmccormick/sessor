factories = angular.module('factories')
factories.factory("ReportFactory", ['$auth', '$resource', 'ParseMapService',
($auth, $resource, ParseMapService)->
	return $resource('api/reports/:id', { format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
		interceptor: {
			response: (response)->
				console.log response.data
				response.data.sections = ParseMapService.map(response.data.sections)
				return response.data
		}
	})

])
