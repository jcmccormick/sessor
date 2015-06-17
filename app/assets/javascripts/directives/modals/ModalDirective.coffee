directives = angular.module('directives')
directives.directive('modal', [ ->
  {
    template: '<div ng-include="getTemplateURL()"></div>'
    restrict: 'E'
    replace: true
    scope: true
    link: (scope, element, attrs) ->
      scope.title = attrs.title
      scope.getTemplateURL = ->
        if attrs.mainTemplate
          'main/modals/' + attrs.mainTemplate + '.html'
      scope.$watch attrs.visible, (value) ->
        if value == true
          $(element).modal 'show'
        else
          $(element).modal 'hide'
        return
      $(element).on 'shown.bs.modal', ->
        scope.$apply ->
          scope.$parent[attrs.visible] = true
          return
        return
      $(element).on 'hidden.bs.modal', ->
        scope.$apply ->
          scope.$parent[attrs.visible] = false
          return
        return
      return
  }
])
