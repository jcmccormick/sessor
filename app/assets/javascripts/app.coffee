sessor = angular.module('sessor', [
  'templates',
  'ngRoute',
  'ngResource',
  'ngStorage',
  'ngDialog',
  'ng-token-auth',
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

      $routeProvider
      .when('/',
        templateUrl: "index.html"
      )
      .when('/reports',
        templateUrl: "show_reports.html"
        controller: 'ReportController'
      )
      .when('/reports/new/',
        templateUrl: "edit_report.html"
        controller: 'ReportController'
      )
      .when('/reports/:reportId',
        templateUrl: "show_report.html"
        controller: 'ReportController'
      )
      .when('/reports/:reportId/edit',
        templateUrl: "edit_report.html"
        controller: 'ReportController'
      )
      .when('/template',
        templateUrl: 'template/main.html'
      )
      .when('/template/create',
        templateUrl: 'template/create.html'
        controller: 'TemplateController'
      )
      .when('/template/:id',
        templateUrl: 'template/view.html'
        controller: 'ViewReportController'
      )
      .when('/draggable',
        templateUrl: "draggable.html"
      )
])

controllers = angular.module('controllers',[])
factories   = angular.module('factories',[])
directives  = angular.module('directives',[])
services    = angular.module('services',[])