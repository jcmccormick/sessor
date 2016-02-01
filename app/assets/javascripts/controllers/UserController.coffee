do ->
    'use strict'

    UserController = ($auth, ipCookie)->

        um = this

        um.auth = (provider)->
            $auth.authenticate(provider).then (res)->
                ipCookie('auth_headers', {
                    "Authorization": 'Token ' + res['auth_token'],
                    'uid': res['uid'],
                    'expiry': res['expiry']
                })

        return um

    UserController.$inject = ['$auth', 'ipCookie']

    angular.module('clerkr').controller("UserController", UserController)