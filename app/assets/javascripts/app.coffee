# Clerkr
# Copyright Joe McCormick 2015 All Rights Reserved
# 
#
#
sessor = angular.module('sessor', [
	'templates',
	'ngRoute',
	'ngResource',
	'ngAnimate',
	'ng-token-auth',
	'ngBootbox',
	'LocalStorageModule',
	'ui.sortable',
	'googlechart',
	'flash',
	'controllers',
	'directives',
	'factories',
	'services',
	'filters'
])

sessor.config(['$authProvider', '$httpProvider', '$routeProvider',
($authProvider, $httpProvider, $routeProvider)->

	authResolver = 'auth': ['$auth', 'localStorageService', 'ReportsService', 'TemplatesService',
	($auth, localStorageService, ReportsService, TemplatesService)->
		$auth.validateUser().then((res)->

			reports = localStorageService.get('_csr')
			templates = localStorageService.get('_cst')

			if !templates || !reports
				TemplatesService.listTemplates().then (res)->
					localStorageService.set('_cst', res)
					ReportsService.listReports().then (rep)->
						return true
			else
				localStorageService.set('_csr', reports)
				localStorageService.set('_cst', templates)
				return true
		)
	]

	$authProvider.configure({
		apiUrl: ""
		omniauthWindowType: 'inAppBrowser'
		authProviderPaths:
			google: '/auth/google_oauth2'
		storage: 'localStorage'
	})
	$httpProvider.interceptors.push('httpInterceptor')

	$routeProvider.when('/',
		templateUrl: "main/index.html"
	)
	.when('/support',
		templateUrl: "main/support.html"
		resolve: authResolver
	)
	.when('/contact',
		templateUrl: "main/contact.html"
		resolve: authResolver
	)
	.when('/sign_out',
		templateUrl: "user/destroy.html"
		resolve: authResolver
	)
	.when('/pass_reset',
		templateUrl: "user/pass.html"
		resolve: authResolver
	)
	.when('/desktop',
		templateUrl: "main/desktop.html"
		resolve: authResolver
	)
	.when('/profile',
		templateUrl: "user/edit.html"
		controller: 'UsersController'
		resolve: authResolver
	) # REPORTS ROUTES #
	.when('/reports',
		templateUrl: "reports/list.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: authResolver
	)
	.when('/reports/new/',
		templateUrl: "reports/edit.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: authResolver
	)
	.when('/reports/:reportId',
		templateUrl: "reports/view.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: authResolver
	)
	.when('/reports/:reportId/edit'
		templateUrl: "reports/edit.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: authResolver
	) # TEMPLATES ROUTES #
	.when('/templates',
		templateUrl: "templates/list.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: authResolver
	)
	.when('/templates/new',
		templateUrl: "templates/edit.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: authResolver
	)
	.when('/templates/:templateId',
		templateUrl: "templates/view.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: authResolver
	)
	.when('/templates/:templateId/edit'
		templateUrl: "templates/edit.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: authResolver
	) # STATISTICS ROUTES #
	.when('/statistics',
		templateUrl: "statistics/show.html"
		controller: 'StatisticsController'
		controllerAs: 'sv'
		resolve: authResolver
	)
	.otherwise('/desktop')
])

controllers = angular.module('controllers',[])
factories	= angular.module('factories',[])
directives	= angular.module('directives',[])
services	= angular.module('services',[])
filters		= angular.module('filters',[])