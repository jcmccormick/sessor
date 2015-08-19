sessor = angular.module('sessor', [
  'templates',
  'ngRoute',
  'ngResource',
  'ngAnimate',
  'ng-token-auth',
  'ngBootbox',
  'ipCookie',
  'ui.sortable',
  'chart.js',
  'infinite-scroll',
  'flash',
  'controllers',
  'directives',
  'factories',
  'services'
])

sessor.config(['$authProvider', '$routeProvider',
  ($authProvider, $routeProvider)->
      $authProvider.configure(
        apiUrl: ""
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
      .when('/sign_out',
        templateUrl: "user_sessions/destroy.html"
        resolve: authResolver
      )
      .when('/profile',
        templateUrl: "user_registrations/edit.html"
        controller: 'UserRegistrationsController'
        resolve: authResolver
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
      ) #                                       STATISTICS ROUTES #
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