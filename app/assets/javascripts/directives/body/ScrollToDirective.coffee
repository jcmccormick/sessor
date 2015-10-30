directives = angular.module('directives')
directives.directive('scrollTo', [ ->
  {
    restrict: 'A'
    scope:
        scrollTo: '@'
        template: '='
        bypass: '@'
    link: (scope, element, attrs)->
        if (scope.template && scope.template.e) || scope.bypass
            length = if scope.bypass then 70 else 250
            element.on 'click', ()->
                setTimeout (()->
                    $('html, body').stop(true, true).animate({scrollTop: $(scope.scrollTo).offset().top-length }, "slow", ()->
                        scope.template.sO.fieldtype && $('#field_name_'+scope.template.sO.section_id+scope.template.sO.column_id+scope.template.sO.id).focus().select()
                    )
                ), 250

  }
])