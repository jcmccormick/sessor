directives = angular.module('directives')
directives.directive('loading', [()->
  {
    template: '<div ng-show="lv.loading">&nbsp;&nbsp;<i class="glyphicon glyphicon-refresh"></i></div>'
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