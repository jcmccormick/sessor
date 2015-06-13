factories = angular.module('factories')
factories.factory("ReportFactory", ['$resource',
($resource)->
	return $resource('reports/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
	})

])
