directives = angular.module('directives')
directives.directive('desktop', [()->
  {
    controllerAs: 'dv'
    controller: ['ReportsService', 'TemplatesService', (ReportsService, TemplatesService)->
      
      dv = this

      dv.reports = ReportsService.listReports()
      dv.templates = TemplatesService.listTemplates()

      return dv

    ]
  }
])