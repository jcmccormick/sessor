factories = angular.module('factories')
factories.factory("ReportFactory", ['$resource', '$q',
($resource, $q)->
	return $resource('reports/:id', { id: '@_id', format: 'json' }, {
		update: {
			method: 'PUT'
			isArray: true
		},
		query: {
			method: 'GET'
			isArray: true
			interceptor: {
				response: (response)->
					return response
			}
		}
	})
])
