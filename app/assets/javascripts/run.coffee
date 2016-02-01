do ->
    'use strict'

    run = ($auth, $location, $rootScope, $route, Flash, ipCookie, localStorageService)->

        $rootScope.$on '$locationChangeSuccess', ->
            if $rootScope.loadedForGA
                $location.$$host != 'localhost' && GoogleAnalytics.trackPageview $location.path
            $rootScope.loadedForGA = true

        $rootScope.$on '$locationChangeStart', (evt, absNewUrl, absOldUrl)->
            ~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')

        $rootScope.$on 'auth:login-success', ->
            $route.reload()
            Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Logged in.</p>', 'customAlert')

        cleanUp = ->
            localStorageService.clearAll()
            console.log ipCookie('_cl_session')
            ipCookie.remove('_cl_session')
            $location.path('/')

        $rootScope.$on 'auth:logout-success', ->
            console.log 'what'
            cleanUp()

        angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
            $rootScope.$on value, ->
                Flash.create('danger', "<h3>Danger! <small>Auth</small></h3><p>Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.</p>", 'customAlert')
                cleanUp()

        $rootScope.$on 'auth:account-update-success', ->
            Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Account updated.</p>', 'customAlert')

    run.$inject = ['$auth', '$location', '$rootScope', '$route', 'Flash', 'ipCookie', 'localStorageService']

    angular.module('clerkr').run(run)