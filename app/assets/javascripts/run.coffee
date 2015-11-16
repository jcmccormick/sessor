angular.module("sessor").run (['$auth', '$rootScope', '$location', '$window', 'Flash', 'localStorageService',
($auth, $rootScope, $location, $window, Flash, localStorageService)->

	$rootScope.$on('$routeChangeStart', (evt, next, current)->
		!$auth.user.id && !current && next.$$route.originalPath == '/' && $auth.validateUser().then((res)-> $location.path('/desktop/'))
	)

	$rootScope.$on('$locationChangeStart', (evt, absNewUrl, absOldUrl)->
		~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')
	)
	
	# $rootScope.$on('$routeChangeSuccess', ->
	# 	$window.ga('send', 'pageview', { page: $location.url() })
	# )

	angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
		$rootScope.$on(value, -> $auth.signOut() && $location.path('/') && Flash.create('danger', "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.", 'customAlert')
		)
	$rootScope.$on('auth:login-success', ->
		Flash.create('success', 'Successfully logged in.', 'customAlert')
		$location.path('/desktop/')
	)

	$rootScope.$on('auth:logout-success', ->
		Flash.create('success', 'You have logged out.', 'customAlert')
		$location.path('/')
	)

	$rootScope.$on('auth:account-update-success', ->
		Flash.create('success', 'Account updated successfully.', 'customAlert')
	)

	$rootScope.clearLocalStorage = ->
		localStorageService.remove('_csr', '_cst')

	$rootScope.handleSignOut = ->
		$location.path('/sign_out')
		$rootScope.signOut()

	$(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
		if $(e.target).is('a')
			$(this).removeClass('in').addClass 'collapse'
	
	$(document).on 'scroll', (->
		$(this).scrollTop() >= 50 && $('.form-header section').addClass('affix')
		$(this).scrollTop() < 50 && $('.form-header section').removeClass('affix')
	)

])