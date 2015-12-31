do ->
    'use strict'

    loadingInterceptor = ($q, $rootScope)->

        loadingCount = 0

        {
            request: (config)->
                ++loadingCount == 1 && $rootScope.$broadcast('loading:progress')
                return config || $q.when(config)

            response: (response)->
                --loadingCount == 0 && $rootScope.$broadcast('loading:finish')
                return response || $q.when(response)

            responseError: (response)->
                response.statusText == 'Unauthorized' && $rootScope.$broadcast('auth:invalid')
                --loadingCount == 0 && $rootScope.$broadcast('loading:finish')
                return $q.reject(response)

        }

    loadingInterceptor.$inject =  ['$q', '$rootScope']

    angular.module('clerkr').factory("loadingInterceptor", loadingInterceptor)