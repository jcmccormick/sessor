directives = angular.module('directives')
directives.directive('scrollTo', [ ->
  {
    restrict: 'A'
    scope:
        scrollTo: '@'
        template: '='
        bypass: '@'
    link: (scope, element, attrs)->
        if (scope.template && scope.template.editing) || scope.bypass
            length = if scope.bypass then 0 else 250
            element.on 'click', ()->
                setTimeout (()->
                    $('html, body').animate({scrollTop: $(scope.scrollTo).offset().top-length }, "slow", ()->
                        $('.page_addition').focus()
                    )
                ), 250

  }
])