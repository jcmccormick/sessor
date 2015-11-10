directives = angular.module('directives')
directives.directive('bsPopover', [ ->
	{
		link: (scope, element, attrs)->
			$(element).find("[rel=popover]").popover({trigger: 'hover'})
	}
])