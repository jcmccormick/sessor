do ->
    'use strict'

    userMenu = ->
        {
            controllerAs: 'uv'
            controller: ['$mdSidenav', '$mdUtil', '$timeout', ($mdSidenav, $mdUtil, $timeout)->
                
                uv = this

                uv.toggleMenu = $mdUtil.debounce (->
                    $mdSidenav('user-menu').toggle()
                ), 300

                uv.closeMenu = ->
                    $mdSidenav('user-menu').close()

                uv.toggleLeftMenu = $mdUtil.debounce (->
                    $mdSidenav('left').toggle()
                ), 300

                uv.closeLeftMenu = ->
                    $mdSidenav('left').close()

                return uv

            ]
        }

    angular.module('clerkr').directive('userMenu', userMenu)