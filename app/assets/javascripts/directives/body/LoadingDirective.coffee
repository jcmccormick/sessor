directives = angular.module('directives')
directives.directive('loading', [()->
  {
    template: '<i ng-show="lv.loading" class="glyphicon glyphicon-refresh"></i>'
    controllerAs: 'lv'
    controller: ['$rootScope', ($rootScope)->

      lv = this

      $rootScope.$on('loading:finish', ->
        lv.loading = false
      )

      $rootScope.$on('loading:progress', ->
        lv.loading = true
      )

      return lv
      
    ]
  }
])