sessor = angular.module('sessor', [
  'templates',
  'ngRoute',
  'ngResource',
  'ngStorage',
  'ng-token-auth',
  'ngBootbox',
  'ipCookie',
  'controllers',
  'directives',
  'factories',
  'services',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
])

sessor.config([ '$routeProvider', 'flashProvider',
  ($routeProvider, flashProvider)->
      flashProvider.errorClassnames.push("alert-danger")
      flashProvider.warnClassnames.push("alert-warning")
      flashProvider.infoClassnames.push("alert-info")
      flashProvider.successClassnames.push("alert-success")

      authResolver = 'auth': ['$auth', ($auth)->
          return $auth.validateUser()
        ]

      $routeProvider
      .when('/',
        templateUrl: "index.html"
      )
      .when('/desktop/',
        templateUrl: "desktop.html"
        resolve: authResolver
      )
      .when('/reports',
        templateUrl: "show_reports.html"
        controller: 'ReportController'
        resolve: authResolver
      )
      .when('/reports/new/',
        templateUrl: "edit_report.html"
        controller: 'ReportController'
        resolve: authResolver
      )
      .when('/reports/:reportId',
        templateUrl: "show_report.html"
        controller: 'ReportController'
        resolve: authResolver
      )
      .when('/reports/:reportId/edit',
        templateUrl: "edit_report.html"
        controller: 'ReportController'
        resolve: authResolver
      )
      .when('/template',
        templateUrl: 'template/main.html'
        resolve: authResolver
      )
      .when('/template/create',
        templateUrl: 'template/create.html'
        controller: 'TemplateController'
        resolve: authResolver
      )
      .when('/template/:id',
        templateUrl: 'template/view.html'
        controller: 'ViewReportController'
        resolve: authResolver
      )
      .otherwise('/')
])

controllers = angular.module('controllers',[])
factories   = angular.module('factories',[])
directives  = angular.module('directives',[])
services    = angular.module('services',[])

sessor.run (['$rootScope','$location',
  ($rootScope, $location) ->
    $rootScope.$on('auth:login-success', ->
      $location.path '/desktop/'
      return
    )
    $rootScope.$on('auth:invalid', ->
      flash.error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue."
      $location.path '/'
      return
    )
    return
])