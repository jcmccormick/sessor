factories = angular.module('factories')
factories.factory("ReportsFactory", ['$auth', '$resource',
($auth, $resource)->
	return $resource('api/reports/', { page: '@_page', format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
	})
])