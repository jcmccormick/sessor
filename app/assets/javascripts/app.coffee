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
  'bgf.paginateAnything',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'controllers',
  'directives',
  'factories',
  'services'
])

sessor.config(['$authProvider', '$routeProvider', 'flashProvider', 'localStorageServiceProvider',
  ($authProvider, $routeProvider, flashProvider, localStorageServiceProvider)->
      localStorageServiceProvider.setPrefix('sesso_')

      flashProvider.errorClassnames.push("alert-danger")
      flashProvider.warnClassnames.push("alert-warning")
      flashProvider.infoClassnames.push("alert-info")
      flashProvider.successClassnames.push("alert-success")

      $authProvider.configure(
        apiUrl: "api/"
      )
      authResolver = 'auth': ['$auth', ($auth)->
        return $auth.validateUser()
      ]

      $routeProvider
      .when('/',
        templateUrl: "main/index.html"
      )
      .when('/support',
        templateUrl: "main/support.html"
      )
      .when('/contact',
        templateUrl: "main/contact.html"
      )
      .when('/sign_up',
        templateUrl: "user_registrations/new.html"
        controller: 'UserRegistrationsController'
      )
      .when('/sign_in',
        templateUrl: "user_sessions/new.html"
        controller: 'UserSessionsController'
      )
      .when('/demo',
        templateUrl: "templates/edit.html"
        controller: 'EditTemplateController'
      )
      .when('/desktop',
        templateUrl: "main/desktop.html"
        resolve: authResolver
      ) #                                       REPORTS ROUTES #
      .when('/reports',
        templateUrl: "reports/show.html"
        controller: 'ShowReportsController'
        resolve: authResolver
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
      .when('/reports/:reportId/edit'
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
      .when('/templates/:templateId/edit'
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

sessor.run (['$rootScope', '$location', '$cacheFactory', '$http', 'flash',
($rootScope, $location, $cacheFactory, $http, flash) ->

  $httpDefaultCache = $cacheFactory.get('$http')

  $rootScope.$on('auth:login-success', ->
    $location.path('/desktop/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:logout-success', ->
    $location.path('/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:invalid', ->
    flash.error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
    $location.path('/')
    return
  )

  angular.forEach [
    'cleartemplates'
    'clearreports'
  ], (value) ->
    $rootScope.$on value, (event) ->
      $httpDefaultCache.removeAll()
      return
    return

  $('ul.nav li.dropdown, #site-nav-view > div:nth-child(2) > div > div > div.stick.col-xs-9.col-sm-6.ng-scope > ul > li').hover (->
    $(this).addClass 'open'
    $(this).find('.dropdown-menu').stop(true, true).fadeIn()
    return
  ), ->
    $(this).removeClass 'open'
    $(this).find('.dropdown-menu').stop(true, true).fadeOut()
    return

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
    return

  $('input[rel="txtTooltip"]').tooltip()

])