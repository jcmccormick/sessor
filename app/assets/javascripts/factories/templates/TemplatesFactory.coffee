factories = angular.module('factories')
factories.factory("TemplatesFactory", ['$auth', '$resource', 'ParseMapService',
($auth, $resource, ParseMapService)->
	return $resource('api/templates/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
		interceptor: {
			response: (response)->
				response.data.forEach (obj) ->
					obj.sections = ParseMapService.map(obj.sections)
				return response.data
		}
	})
])