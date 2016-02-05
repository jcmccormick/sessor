do ->
    'use strict'

    run = ($auth, $location, $rootScope, $route, $window, Flash, ipCookie, localStorageService)->

        $rootScope.$on '$locationChangeSuccess', ->
            if $rootScope.loadedForGA
                $location.$$host != 'localhost' && GoogleAnalytics.trackPageview $location.path
            $rootScope.loadedForGA = true

        $rootScope.$on '$locationChangeStart', (evt, absNewUrl, absOldUrl)->
            ~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')

        cleanUp = ->
            $location.path('/')
            localStorageService.clearAll()
            ipCookie.remove('_cl_session')

        angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
            $rootScope.$on value, ->
                Flash.create('danger', "<h3>Danger! <small>Auth</small></h3><p>Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.</p>", 'customAlert')
                cleanUp()

        $rootScope.$on 'auth:logout-success', ->
            cleanUp()

        $window.onbeforeunload = cleanUp()

    run.$inject = ['$auth', '$location', '$rootScope', '$route', '$window', 'Flash', 'ipCookie', 'localStorageService']

    angular.module('clerkr').run(run)