do ->
    'use strict'

    ClassFactory = ($resource)->
        $resource 'v1/:class/:id', { format: 'json' }, {
            query:
                method: 'GET'
                isArray: true
                cache: true
            update:
                method: 'PUT'
                isArray: true
            get:
                cache: false
                isArray: false
        }

    ClassFactory.$inject = ['$resource']

    angular.module('clerkr').factory("ClassFactory", ClassFactory)