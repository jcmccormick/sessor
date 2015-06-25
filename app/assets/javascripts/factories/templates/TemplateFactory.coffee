factories = angular.module('factories')
factories.factory("TemplateFactory", ['$auth', '$resource', 'ParseMapService',
($auth, $resource, ParseMapService)->
	return $resource('api/templates/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
		interceptor: {
			response: (response)->
				response.data.sections = ParseMapService.map(response.data.sections)
				return response.data
		}
	})

])
