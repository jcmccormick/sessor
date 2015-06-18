factories = angular.module('factories')
factories.factory("ReportFactory", ['$resource',
($resource)->
	return $resource('reports/:id', { id: '@_id', format: 'json' }, {
	update:
		method: 'PUT'
		isArray: true
	get:
		cache: true
		isArray: false
		interceptor: {
			response: (response)->
				jsonData = JSON.parse(response.data.template)
				response.data.sections = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				jsonData = JSON.parse(response.data.participants)
				response.data.participants = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				return response.data
		}
	})

])
