factories = angular.module('factories')
factories.factory("TemplateFactory", ['$auth', '$resource',
($auth, $resource)->
	return $resource('api/templates/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
		interceptor: {
			response: (response)->
				jsonData = JSON.parse(response.data.sections)
				response.data.sections = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				return response.data
		}
	})

])
