sessor = angular.module('sessor', [
  'templates',
  'ngRoute',
  'ngResource',
  'ngAnimate',
  'LocalStorageModule',
  'ng-token-auth',
  'ngBootbox',
  'ipCookie',
  'ui.sortable',
  'chart.js',
  'bgf.paginateAnything',
  'flash',
  'controllers',
  'directives',
  'factories',
  'services'
])

sessor.config(['$authProvider', '$routeProvider', 'localStorageServiceProvider',
  ($authProvider, $routeProvider, localStorageServiceProvider)->
      localStorageServiceProvider.setPrefix('sesso_')

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
        controller: 'StatisticsController'
        resolve: authResolver
      )
      .otherwise('/')
])

controllers = angular.module('controllers',[])
factories   = angular.module('factories',[])
directives  = angular.module('directives',[])
services    = angular.module('services',[])

sessor.factory("sessorCache", ['$cacheFactory', ($cacheFactory)-> 
  return $cacheFactory('reports')
])

sessor.run (['$rootScope', '$location', '$cacheFactory', '$http', 'Flash',
($rootScope, $location, $cacheFactory, $http, Flash) ->

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
    error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
    Flash.create('error', error)
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

  $('input[rel="txtTooltip"]').tooltip()

  mobileDevice = if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) then true else false

  if !mobileDevice
    $('ul.nav li.dropdown').hover (->
      $(this).delay(200).addClass('open')
      $(this).find('.dropdown-menu').first().stop(true, true).slideDown()
      return
    ), ->
      $(this).delay(200).removeClass('open')
      $(this).find('.dropdown-menu').first().stop(true, true).slideUp()
      return

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
    return


])