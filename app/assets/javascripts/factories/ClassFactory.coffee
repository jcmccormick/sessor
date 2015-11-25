factories = angular.module('factories')
factories.factory("ClassFactory", ['$resource',
($resource)->
	return $resource('v1/:class/:id', { format: 'json' }, {
		query:
			method: 'GET'
			isArray: true
			cache: true
		update:
			method: 'PUT'
			isArray: true
		get:
			cache: false
			isArray: false
	})
])