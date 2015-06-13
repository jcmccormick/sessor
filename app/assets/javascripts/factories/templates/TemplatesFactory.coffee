factories = angular.module('factories')
factories.factory("TemplatesFactory", ['$resource', '$cacheFactory',
($resource, $cacheFactory)->
	return $resource('templates/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
	})
])