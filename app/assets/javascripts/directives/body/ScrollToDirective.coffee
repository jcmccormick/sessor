directives = angular.module('directives')
directives.directive('scrollTo', [ ->
  {
    restrict: 'A'
    scope:
        scrollTo: '@'
        template: '='
    link: (scope, element, attrs)->
        if scope.template && scope.template.editing
            element.on 'click', ()->
                setTimeout (()->
                    $('html, body').animate({scrollTop: $(scope.scrollTo).offset().top-250 }, "slow", ()->
                        $('.page_addition').focus()
                    )
                ), 250

  }
])