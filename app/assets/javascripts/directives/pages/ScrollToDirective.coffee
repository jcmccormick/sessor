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
						$('html, body').stop(true, true).animate({scrollTop: $(scope.scrollTo).offset().top-length }, "slow")
						if scope.template.sO.fieldtype
							$('#field_name_'+scope.template.sO.o.section_id+scope.template.sO.o.column_id+scope.template.sO.id).focus().select()
						else if scope.template.sO.i
							$('#section-'+scope.template.sO.i+'-name').focus().select()
					), 25
	}
])