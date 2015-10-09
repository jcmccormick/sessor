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
            length = if scope.bypass then 70 else 250
            element.on 'click', ()->
                setTimeout (()->
                    $('html, body').animate({scrollTop: $(scope.scrollTo).offset().top-length }, "slow", ()->
                        if !scope.bypass
                            $('.page_addition').focus()
                    )
                ), 250

  }
])