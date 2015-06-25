factories = angular.module('factories')
factories.factory("ReportsFactory", ['$auth', '$resource', 'ParseMapService',
($auth, $resource, ParseMapService)->
	return $resource('api/reports/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
		interceptor: {
			response: (response)->
				response.data.forEach (obj) ->
					obj.sections = ParseMapService.map(obj.template)
				return response.data
		}
	})
])