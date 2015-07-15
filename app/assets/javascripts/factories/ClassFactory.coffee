factories = angular.module('factories')
factories.factory("ClassFactory", ['$auth', '$resource',
($auth, $resource)->
	return $resource('api/:class/:id', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: true
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
	})
])