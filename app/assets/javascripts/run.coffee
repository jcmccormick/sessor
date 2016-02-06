do ->
    'use strict'

    run = ($auth, $location, $rootScope, $timeout, $window, Flash, ipCookie, localStorageService)->

        $rootScope.$on '$locationChangeSuccess', ->
            $rootScope.loadedForGA && $location.$$host != 'localhost' && GoogleAnalytics.trackPageview $location.path
            $rootScope.loadedForGA = true

        $rootScope.$on 'auth:login-success', ->
            if $auth.user.googler == "t"
                $timeout (->
                    if !$auth.user.driveLoggedIn
                        $auth.authenticate('google',{ params: { scope: 'email, profile, https://spreadsheets.google.com/feeds/, https://www.googleapis.com/auth/drive.file'}})
                        $auth.user.driveLoggedIn = true
                    else
                        location.reload()
                ), 0
            else
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


    run.$inject = ['$auth', '$location', '$rootScope', '$timeout', '$window', 'Flash', 'ipCookie', 'localStorageService']

    angular.module('clerkr').run(run)