do ->
    'use strict'

    clocation = ->
        {
            controllerAs: 'lv'
            controller: ['$location', ($location)->
                
                lv = this

                lv.locate = (path)->
                    $location.path(path)

                return lv

            ]
        }

    angular.module('clerkr').directive('clocation', clocation)