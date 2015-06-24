factories = angular.module('factories')
factories.factory("ReportsFactory", ['$auth', '$resource', '$cacheFactory',
($auth, $resource, $cacheFactory)->
	return $resource('api/reports/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
		interceptor: {
			response: (response)->
				response.data.forEach (obj) ->
					obj.sections = []
					jsonData = JSON.parse(obj.template)
					obj.sections = $.map(jsonData, (value, index)->
						value.key = index
						return [value]
					)
				return response.data
		}
	})
])