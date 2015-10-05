factories = angular.module('factories')
factories.factory("httpInterceptor", ['$q', '$rootScope', '$log',
($q, $rootScope, $log)->

	loadingCount = 0

	{
		request: (config)->
			if ++loadingCount == 1 then $rootScope.$broadcast('loading:progress')
			return config || $q.when(config)

		response: (response)->
			if --loadingCount == 0 then $rootScope.$broadcast('loading:finish')
			return response || $q.when(response)

		responseError: (response)->
			if --loadingCount == 0 then $rootScope.$broadcast('loading:finish')
			return $q.reject(response)

	}
])