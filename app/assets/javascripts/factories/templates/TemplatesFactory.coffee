factories = angular.module('factories')
factories.factory("TemplatesFactory", ['$auth', '$resource', '$cacheFactory',
($auth, $resource, $cacheFactory)->
	return $resource('api/templates/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
		interceptor: {
			response: (response)->
				response.data.forEach (obj) ->
					jsonData = JSON.parse(obj.sections)
					obj.sections = $.map(jsonData, (value, index)->
						value.key = index
						return [value]
					)
				return response.data
		}
	})
])