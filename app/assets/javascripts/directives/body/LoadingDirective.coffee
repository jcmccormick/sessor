directives = angular.module('directives')
directives.directive('loading', [()->
  {
    template: '<div ng-if="lv.loading"><div><i class="glyphicon glyphicon-refresh"></i></div></div>'
    scope: false
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