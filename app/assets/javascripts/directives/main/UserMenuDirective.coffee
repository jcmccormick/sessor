do ->
    'use strict'

    userMenu = ->
        {
            controllerAs: 'uv'
            controller: ['$mdSidenav', '$mdUtil', '$timeout', ($mdSidenav, $mdUtil, $timeout)->
                
                uv = this

                uv.toggleMenu = $mdUtil.debounce (->
                    $mdSidenav('right').toggle()
                ), 300

                uv.closeMenu = ->
                    $mdSidenav('right').close()

                uv.toggleLeftMenu = $mdUtil.debounce (->
                    $mdSidenav('left').toggle()
                ), 300

                uv.closeLeftMenu = ->
                    $mdSidenav('left').close()

                return uv

            ]
        }

    angular.module('clerkr').directive('userMenu', userMenu)