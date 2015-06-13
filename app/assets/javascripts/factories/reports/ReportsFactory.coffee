factories = angular.module('factories')
factories.factory("ReportsFactory", ['$resource', '$cacheFactory',
($resource, $cacheFactory)->
	return $resource('reports/', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
	})
])