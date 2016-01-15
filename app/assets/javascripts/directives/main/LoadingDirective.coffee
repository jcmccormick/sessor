do ->
    'use strict'

    loading = ->
        {
            template: '<md-progress-linear md-mode="indeterminate" ng-if="lv.loading"></md-progress-linear>'
            scope: false
            controllerAs: 'lv'
            controller: ['$rootScope', ($rootScope)->

                lv = this

                $rootScope.$on('loading:finish', ->
                    lv.loading = false
                )

                $rootScope.$on('loading:progress', ->
                    lv.loading = true
                )

                return lv
                
            ]
        }

    angular.module('clerkr').directive('loading', loading)