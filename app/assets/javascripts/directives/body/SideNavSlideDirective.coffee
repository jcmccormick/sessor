directives = angular.module('directives')
directives.directive('sideNavSlide', [ ->
    return (scope, element, attrs)->
        if $(window).width() > 750
            $(element).hover (->
                $(this).animate({'width': '225px'},25)
                $('.view-frame').animate({'left': '225px'},25)
                return
            ), ->
                $(this).animate({'width': '48px'},25)
                $('.view-frame').animate({'left': '48px'},25)
                return

            $(element).click (->
                $(this).css 'width': '48px'
                $('.view-frame').css 'left': '48px'
            )
])