directives = angular.module('directives')
directives.directive('desktop', [()->
  {
    controllerAs: 'dv'
    controller: ['DesktopService', (DesktopService)->
      
      dv = this

      DesktopService.getDesktop(dv)

      return dv

    ]
  }
])