do ->
	'use strict'

	scrollTo = ->
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

							# This will focus on the section/field name after scrolling, 
							# but it's very annoying on mobile
							
							# if scope.template
							# 	if scope.template.sO.fieldtype
							# 		$('#field_name_'+scope.template.sO.o.section_id+scope.template.sO.o.column_id+scope.template.sO.id).focus().select()
							# 	else if scope.template.sO.i
							# 		$('#section-'+scope.template.sO.i+'-name').focus().select()
						), 25
		}

	angular.module('clerkr').directive('scrollTo', scrollTo)