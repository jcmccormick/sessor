directives = angular.module('directives')
directives.directive('modalHide', [ ->
  return {
    scope: {
      model: '='
    }
    link: (scope, ele, attrs)->
      ele.bind 'hidden.bs.modal', ->
        scope.model[attrs.showModal] = false
        scope.$apply()
  }
])
