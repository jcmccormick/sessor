directives = angular.module('directives')
directives.directive('bsPopover', [ ->
  return (scope, element, attrs)->
    element.find("i[rel=popover]").popover({trigger: 'hover'})  
])