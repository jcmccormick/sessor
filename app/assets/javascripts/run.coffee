do ->
    'use strict'

    run = ($location, $rootScope, $route, $timeout, $window, Flash, ipCookie, localStorageService)->

        $rootScope.$on '$locationChangeSuccess', ->
            if $rootScope.loadedForGA
                $location.$$host != 'localhost' && GoogleAnalytics.trackPageview $location.path
            $rootScope.loadedForGA = true

        $rootScope.$on '$locationChangeStart', (evt, absNewUrl, absOldUrl)->
            ~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')

        $rootScope.$on 'auth:login-success', ->
            console.log 'You just logged in.'
            location.reload()

        $rootScope.$on 'auth:account-update-success', ->
            Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Account updated.</p>', 'customAlert')

        cleanUp = ->
            localStorageService.clearAll()
            ipCookie.remove('_cl_session')

        angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
            $rootScope.$on value, ->
                Flash.create('danger', "<h3>Danger! <small>Auth</small></h3><p>Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.</p>", 'customAlert')
                cleanUp()

        $rootScope.$on 'auth:logout-success', ->
            $location.path('/')
            cleanUp()

        $window.onbeforeunload = cleanUp()

    run.$inject = ['$location', '$rootScope', '$route', '$timeout', '$window', 'Flash', 'ipCookie', 'localStorageService']

    angular.module('clerkr').run(run)