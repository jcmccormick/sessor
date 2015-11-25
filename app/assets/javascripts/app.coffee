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

	resolver = 'auth': ['$auth', 'localStorageService', 'ReportsService', 'TemplatesService',
	($auth, localStorageService, ReportsService, TemplatesService)->
		$auth.validateUser().then ->
			reports = localStorageService.get('_csr')
			templates = localStorageService.get('_cst')

			if !templates || !reports
				TemplatesService.listTemplates().then (res)->
					localStorageService.set('_cst', res)
					ReportsService.listReports().then (rep)->
						localStorageService.set('_csr', rep)
						return true
			else
				localStorageService.set('_csr', reports)
				localStorageService.set('_cst', templates)
	]

	$authProvider.configure({
		apiUrl: ""
		storage: 'localStorage'
	})
	$httpProvider.interceptors.push('httpInterceptor')

	$routeProvider.when('/',
		templateUrl: "main/index.html"
		resolve: resolver
	)
	.when('/support',
		templateUrl: "main/support.html"
		resolve: resolver
	)
	.when('/contact',
		templateUrl: "main/contact.html"
		resolve: resolver
	)
	.when('/pass_reset',
		templateUrl: "user/pass.html"
		resolve: resolver
	)
	.when('/profile',
		templateUrl: "user/edit.html"
		controller: 'UsersController'
		resolve: resolver
	) # REPORTS ROUTES #
	.when('/reports',
		templateUrl: "reports/list.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: resolver
	)
	.when('/reports/new/',
		templateUrl: "reports/edit.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: resolver
	)
	.when('/reports/:reportId',
		templateUrl: "reports/view.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: resolver
	)
	.when('/reports/:reportId/edit'
		templateUrl: "reports/edit.html"
		controller: 'ReportsController'
		controllerAs: 'vr'
		resolve: resolver
	) # TEMPLATES ROUTES #
	.when('/templates',
		templateUrl: "templates/list.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: resolver
	)
	.when('/templates/new',
		templateUrl: "templates/edit.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: resolver
	)
	.when('/templates/:templateId',
		templateUrl: "templates/view.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: resolver
	)
	.when('/templates/:templateId/edit'
		templateUrl: "templates/edit.html"
		controller: 'TemplatesController'
		controllerAs: 'vt'
		resolve: resolver
	) # STATISTICS ROUTES #
	.when('/statistics',
		templateUrl: "statistics/show.html"
		controller: 'StatisticsController'
		controllerAs: 'sv'
		resolve: resolver
	)
	.otherwise('/')
])

controllers = angular.module('controllers',[])
factories	= angular.module('factories',[])
directives	= angular.module('directives',[])
services	= angular.module('services',[])
filters		= angular.module('filters',[])