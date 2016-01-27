// Generated by CoffeeScript 1.9.3
(function() {
  'use strict';
  var config;
  config = function($authProvider, $httpProvider, $routeProvider, $locationProvider) {
    var resolver;
    $locationProvider.html5Mode(true);
    $httpProvider.interceptors.push('loadingInterceptor');
    $authProvider.configure({
      apiUrl: '',
      storage: 'localStorage',
      apiProviderPaths: {
        google: 'auth/google_oauth2'
      }
    });
    resolver = {
      'auth': [
        '$auth', 'localStorageService', 'ReportsService', 'TemplatesService', function($auth, localStorageService, ReportsService, TemplatesService) {
          return $auth.validateUser().then(function() {
            var reports, templates;
            reports = localStorageService.get('_csr');
            templates = localStorageService.get('_cst');
            if (!templates || !reports) {
              return TemplatesService.listTemplates().then(function(res) {
                $auth.user.templates_count = res.length;
                localStorageService.set('_cst', res);
                return ReportsService.listReports().then(function(rep) {
                  localStorageService.set('_csr', rep);
                  $auth.user.reports_count = rep.length;
                  return true;
                });
              });
            } else {
              localStorageService.set('_csr', reports);
              localStorageService.set('_cst', templates);
              $auth.user.reports_count = reports.length;
              return $auth.user.templates_count = templates.length;
            }
          });
        }
      ]
    };
    return $routeProvider.when('/', {
      templateUrl: "main/index.html",
      resolve: resolver,
      redirectTo: function(current, path, search) {
        return (search.goto && '/' + search.goto) || '/';
      }
    }).when('/contact', {
      templateUrl: "main/contact.html",
      resolve: resolver
    }).when('/reports', {
      templateUrl: "reports/list.html",
      controller: 'ReportsController',
      controllerAs: 'vr',
      resolve: resolver
    }).when('/reports/new/', {
      templateUrl: "reports/edit.html",
      controller: 'ReportsController',
      controllerAs: 'vr',
      resolve: resolver
    }).when('/reports/:reportId', {
      templateUrl: "reports/view.html",
      controller: 'ReportsController',
      controllerAs: 'vr',
      resolve: resolver
    }).when('/reports/:reportId/edit', {
      templateUrl: "reports/edit.html",
      controller: 'ReportsController',
      controllerAs: 'vr',
      resolve: resolver
    }).when('/templates', {
      templateUrl: "templates/list.html",
      controller: 'TemplatesController',
      controllerAs: 'vt',
      resolve: resolver
    }).when('/templates/new', {
      templateUrl: "templates/edit.html",
      controller: 'TemplatesController',
      controllerAs: 'vt',
      resolve: resolver
    }).when('/templates/:templateId', {
      templateUrl: "templates/view.html",
      controller: 'TemplatesController',
      controllerAs: 'vt',
      resolve: resolver
    }).when('/templates/:templateId/edit', {
      templateUrl: "templates/edit.html",
      controller: 'TemplatesController',
      controllerAs: 'vt',
      resolve: resolver
    }).when('/statistics', {
      templateUrl: "statistics/show.html",
      controller: 'StatisticsController',
      controllerAs: 'sv',
      resolve: resolver
    }).otherwise('/');
  };
  config.$inject = ['$authProvider', '$httpProvider', '$routeProvider', '$locationProvider'];
  return angular.module('clerkr').config(config);
})();