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
	'ipCookie',
	'ui.sortable',
	'googlechart',
	'infinite-scroll',
	'flash',
	'controllers',
	'directives',
	'factories',
	'services',
	'filters'
])

sessor.config(['$authProvider', '$httpProvider', '$routeProvider',
($authProvider, $httpProvider, $routeProvider)->

	authResolver = 'auth': ['$auth', ($auth)-> $auth.validateUser()]

	$authProvider.configure(apiUrl: "")
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
		controller: 'UserRegistrationsController'
		resolve: authResolver
	) # REPORTS ROUTES #
	.when('/reports',
		templateUrl: "reports/show.html"
		controller: 'ShowReportsController'
		controllerAs: 'vrs'
		resolve: authResolver
	)
	.when('/reports/new/',
		templateUrl: "reports/edit.html"
		controller: 'EditReportController'
		controllerAs: 'vr'
		resolve: authResolver
	)
	.when('/reports/:reportId',
		templateUrl: "reports/view.html"
		controller: 'ViewReportController'
		controllerAs: 'vr'
		resolve: authResolver
	)
	.when('/reports/:reportId/edit'
		templateUrl: "reports/edit.html"
		controller: 'EditReportController'
		controllerAs: 'vr'
		resolve: authResolver
	) # TEMPLATES ROUTES #
	.when('/templates',
		templateUrl: "templates/show.html"
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