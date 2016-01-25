do ->
    'use strict'

    startFrom = ->
        (input, start)->
            if input
                start = +start
                input.slice start

    angular.module('clerkr').filter("startFrom", startFrom)