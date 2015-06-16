factories = angular.module('factories')
factories.factory("TemplatesFactory", ['$resource', '$cacheFactory',
($resource, $cacheFactory)->
	return $resource('templates/', { format: 'json' }, {
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