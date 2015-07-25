directives = angular.module('directives')
directives.directive('viewAllAccordion', [ ->
  return (scope, element, attrs)->
    element.hover (->
      element.find('.view-all-panel').collapse("show")
      return
    ),(->
      setTimeout((->
        element.find('.view-all-panel').collapse("hide")
        return
      ), 500)
    )
])