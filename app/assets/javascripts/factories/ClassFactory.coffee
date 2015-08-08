factories = angular.module('factories')
factories.factory("ClassFactory", ['$auth', '$resource', 'SessorCache',
($auth, $resource, SessorCache)->
	return $resource('v1/:class/:id', { format: 'json' }, {
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