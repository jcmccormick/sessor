do ->
    'use strict'

    bsPopover = ->
        {
            link: (scope, element, attrs)->
                $(element).find("[rel=popover]").popover({trigger: 'hover'})
        }

    angular.module('clerkr').directive('bsPopover', bsPopover)