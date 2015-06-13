factories = angular.module('factories')
factories.factory("TemplateFactory", ['$resource',
($resource)->
	return $resource('templates/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
	})

])
