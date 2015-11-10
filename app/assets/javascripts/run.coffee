angular.module("sessor").run (['$auth', '$rootScope', '$location', '$cacheFactory', '$window', 'ClassFactory', 'Flash', 'ReportsService', 'TemplatesService',
($auth, $rootScope, $location, $cacheFactory, $window, ClassFactory, Flash, ReportsService, TemplatesService)->

	$httpDefaultCache = $cacheFactory.get('$http')

	angular.forEach ['cleartemplates','clearreports'], (value)->
		$rootScope.$on(value, (event) ->
			$httpDefaultCache.removeAll()
		)

	$rootScope.$on('$routeChangeStart', (evt, next, current)->
		!$auth.user.id && !current && next.$$route.originalPath == '/' && $auth.validateUser().then((res)-> $location.path('/desktop/'))
	)

	$rootScope.$on('$locationChangeStart', (evt, absNewUrl, absOldUrl)->
		~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')
	)
	
	$rootScope.$on('$routeChangeSuccess', ->
		$window.ga('send', 'pageview', { page: $location.url() })
	)

	angular.forEach ['auth:login-success', 'auth:validation-success'], (value)->
		$rootScope.$on(value, ->
			ClassFactory.get({class: 'desktop_statistics'}, (res)->
				$.extend ReportsService.listReports(), res.reports
				$.extend TemplatesService.listTemplates(), res.templates
			)
		)
	angular.forEach ['auth:invalid', 'auth:validation-error'], (value)->
		$rootScope.$on(value, ->
			$auth.signOut()
			$location.path('/')
			error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue."
			Flash.create('danger', error, 'customAlert')
		)
	$rootScope.$on('auth:login-success', ->
		Flash.create('success', 'Successfully logged in.', 'customAlert')
		$location.path('/desktop/')
		$httpDefaultCache.removeAll()
	)

	$rootScope.$on('auth:logout-success', ->
		ReportsService.listReports().length = 0
		TemplatesService.listTemplates().length = 0
		Flash.create('success', 'You have logged out.', 'customAlert')
		$location.path('/')
		$httpDefaultCache.removeAll()
	)

	$rootScope.$on('auth:account-update-success', ->
		Flash.create('success', 'Account updated successfully.', 'customAlert')
	)

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