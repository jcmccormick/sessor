angular.module("sessor").run (['$auth', '$rootScope', '$location', '$window', 'Flash', 'localStorageService',
($auth, $rootScope, $location, $window, Flash, localStorageService)->

	# $rootScope.$on('$routeChangeStart', (evt, next, current)->
	# 	if !$auth.user.id && !current && (next.$$route.originalPath == '/' || next.$$route.originalPath == '/desktop')
	# 		$auth.validateUser().then ((res)->
	# 			$location.path('/desktop')
	# 		), (err)->
	# 			$location.path('/')
	# )

	$rootScope.$on('$locationChangeStart', (evt, absNewUrl, absOldUrl)->
		~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')
	)
	
	$rootScope.$on('$routeChangeSuccess', ->
		$window.ga('send', 'pageview', { page: $location.url() })
	)

	angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
		$rootScope.$on(value, ->
			$auth.signOut()
			$location.path('/')
			Flash.create('danger', "<h3>Danger! <small>Auth</small></h3><p>Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue.</p>", 'customAlert')
		)
	$rootScope.$on('auth:login-success', ->
		Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Logged in.</p>', 'customAlert')
		$location.path('/desktop')
	)

	$rootScope.$on('auth:logout-success', ->
		Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Logged out.</p>', 'customAlert')
		$location.path('/')
	)

	$rootScope.$on('auth:account-update-success', ->
		Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>Account updated.</p>', 'customAlert')
	)

	$rootScope.clearLocalStorage = ->
		localStorageService.clearAll()

	$rootScope.handleSignOut = ->
		$location.path('/sign_out')
		localStorageService.clearAll()
		$rootScope.signOut()

	$(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
		if $(e.target).is('a')
			$(this).removeClass('in').addClass 'collapse'
	
	$(document).on 'scroll', (->
		!$('.form-header section').hasClass('affix') && $(this).scrollTop() >= 50 && $('.form-header section').addClass('affix')
		$('.form-header section').hasClass('affix') && $(this).scrollTop() < 50 && $('.form-header section').removeClass('affix')
	)

])