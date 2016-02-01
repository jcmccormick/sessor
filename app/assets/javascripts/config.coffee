do ->
    'use strict'

    config = ($authProvider, $httpProvider, $routeProvider, $locationProvider)->

        $locationProvider.html5Mode true

        $httpProvider.interceptors.push 'loadingInterceptor'

        $authProvider.configure
            apiUrl: ''

        resolver = 'auth': ['$auth', 'localStorageService', 'ReportsService', 'TemplatesService',
        ($auth, localStorageService, ReportsService, TemplatesService)->
            $auth.validateUser().then ->
                reports = localStorageService.get('_csr')
                templates = localStorageService.get('_cst')

                if !templates || !reports
                    TemplatesService.listTemplates().then (res)->
                        $auth.user.templates_count = res.length
                        localStorageService.set('_cst', res)
                        ReportsService.listReports().then (rep)->
                            localStorageService.set('_csr', rep)
                            $auth.user.reports_count = rep.length
                            return true
                else
                    localStorageService.set('_csr', reports)
                    localStorageService.set('_cst', templates)
                    $auth.user.reports_count = reports.length
                    $auth.user.templates_count = templates.length                

        ]

        $routeProvider.when('/',
            templateUrl: "main/index.html"
            resolve: resolver
            redirectTo: (current, path, search)->
                (search.goto && '/'+search.goto) || '/'
        )
        .when('/contact',
            templateUrl: "main/contact.html"
            resolve: resolver
        )
        # .when('/support',
        #     templateUrl: "main/support.html"
        #     resolve: resolver
        # )
        # .when('/pass_reset',
        #     templateUrl: "user/pass.html"
        #     resolve: resolver
        # )
        # .when('/profile',
        #     templateUrl: "user/edit.html"
        #     controller: 'UsersController'
        #     resolve: resolver
        # ) # REPORTS ROUTES #
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

    config.$inject = ['$authProvider', '$httpProvider', '$routeProvider', '$locationProvider']

    angular.module('clerkr').config(config)