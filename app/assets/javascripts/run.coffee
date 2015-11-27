do ->
	'use strict'

	run = ($auth, $location, $rootScope, Flash, localStorageService)->

		$rootScope.$on '$locationChangeSuccess', ->
			if $rootScope.loadedForGA
				$location.$$host != 'localhost' && GoogleAnalytics.trackPageview $location.path
			$rootScope.loadedForGA = true

		$rootScope.$on '$locationChangeStart', (evt, absNewUrl, absOldUrl)->
			~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')

		$rootScope.$on 'auth:login-success', ->
			Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Logged in.</p>', 'customAlert')

		$rootScope.$on 'auth:logout-success', ->
			Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Logged out.</p>', 'customAlert')
			localStorageService.clearAll()
			$location.path('/')

		angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
			$rootScope.$on value, ->
				Flash.create('danger', "<h3>Danger! <small>Auth</small></h3><p>Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.</p>", 'customAlert')
				localStorageService.clearAll()
				$location.path('/')

		$rootScope.$on 'auth:account-update-success', ->
			Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Account updated.</p>', 'customAlert')

		$rootScope.clearLocalStorage = ->
			localStorageService.clearAll()

		$rootScope.handleSignOut = ->
			$rootScope.signOut()

		$(document).on 'click.nav li', '.navbar-collapse.in', (e)->
			if $(e.target).is('a')
				$(this).removeClass('in').addClass 'collapse'

		$(document).on 'scroll', ->
			!$('.form-header section').hasClass('affix') && $(this).scrollTop() >= 50 && $('.form-header section').addClass('affix')
			$('.form-header section').hasClass('affix') && $(this).scrollTop() < 50 && $('.form-header section').removeClass('affix')

	run.$inject = ['$auth', '$location', '$rootScope', 'Flash', 'localStorageService']

	angular.module('clerkr').run(run)