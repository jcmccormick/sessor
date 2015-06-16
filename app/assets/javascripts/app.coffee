sessor = angular.module('sessor', [
  'templates',
  'ngRoute',
  'ngResource',
  'LocalStorageModule',
  'ng-token-auth',
  'ngBootbox',
  'ipCookie',
  'ui.sortable',
  'chart.js',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'controllers',
  'directives',
  'factories',
  'services'
])

sessor.config([ '$routeProvider', 'flashProvider', 'localStorageServiceProvider',
  ($routeProvider, flashProvider, localStorageServiceProvider)->
      localStorageServiceProvider
        .setPrefix('sesso_')
      flashProvider.errorClassnames.push("alert-danger")
      flashProvider.warnClassnames.push("alert-warning")
      flashProvider.infoClassnames.push("alert-info")
      flashProvider.successClassnames.push("alert-success")

      authResolver = 'auth': ['$auth', ($auth)->
        return $auth.validateUser()
      ]

      $routeProvider
      .when('/',
        templateUrl: "main/index.html"
      )
      .when('/desktop',
        templateUrl: "main/desktop.html"
        resolve: authResolver
      ) #                                       REPORTS ROUTES #
      .when('/reports',
        templateUrl: "reports/show.html"
        controller: 'ShowReportsController'
      )
      .when('/reports/new/',
        templateUrl: "reports/edit.html"
        controller: 'EditReportController'
        resolve: authResolver
      )
      .when('/reports/:reportId',
        templateUrl: "reports/view.html"
        controller: 'ViewReportController'
        resolve: authResolver
      )
      .when('/reports/:reportId/edit',
        templateUrl: "reports/edit.html"
        controller: 'EditReportController'
        resolve: authResolver
      ) #                                       TEMPLATES ROUTES #
      .when('/templates',
        templateUrl: "templates/show.html"
        controller: 'ShowTemplatesController'
        resolve: authResolver
      )
      .when('/templates/new',
        templateUrl: "templates/edit.html"
        controller: 'EditTemplateController'
        resolve: authResolver
      )
      .when('/templates/:templateId',
        templateUrl: "templates/view.html"
        controller: 'ViewTemplateController'
        resolve: authResolver
      )
      .when('/templates/:templateId/edit',
        templateUrl: "templates/edit.html"
        controller: 'EditTemplateController'
        resolve: authResolver
      )
      .when('/statistics',
        templateUrl: "statistics/show.html"
        controller: 'ReportsStatisticsController'
        resolve: authResolver
      )
      .otherwise('/')
])

sessor.factory("sessorCache", ['$cacheFactory', ($cacheFactory)-> 
  return $cacheFactory('reports')
])

controllers = angular.module('controllers',[])
factories   = angular.module('factories',[])
directives  = angular.module('directives',[])
services    = angular.module('services',[])

sessor.run (['$rootScope','$location', '$cacheFactory', '$http', 'flash',
  ($rootScope, $location, $cacheFactory, $http, flash) ->
    $rootScope.$on('auth:login-success', ->
      $location.path('/desktop/')
      return
    )
    $rootScope.$on('auth:invalid', ->
      flash.error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
      $location.path('/')
      return
    )
    $httpDefaultCache = $cacheFactory.get('$http')
    angular.forEach [
      'cleartemplates'
      'clearreports'
    ], (value) ->
      $rootScope.$on value, (event) ->
        $httpDefaultCache.removeAll()
        return
      return
])