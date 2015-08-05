factories = angular.module('factories')
factories.factory("ClassFactory", ['$auth', '$resource', 'SessorCache',
($auth, $resource, SessorCache)->
	return $resource('v1/:class/:id', { format: 'json' }, {
	query:
		method: 'GET'
		isArray: true
		cache: SessorCache
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: SessorCache
		isArray: false
	})
])