directives = angular.module('directives')
directives.directive('scrollTo', [ ->
  {
    restrict: 'A'
    scope:
        scrollTo: '@'
    link: (scope, element, attrs)->
        element.on 'click', ()->
            $('html, body').animate({scrollTop: $(scope.scrollTo).offset().top-100 }, "ease")
            $('#page_addition').focus()
  }
])