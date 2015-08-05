directives = angular.module('directives')
directives.directive('panelHide', [ ->
	return {
		link: (scope, ele, attrs)->

			ele.bind 'show.bs.collapse', ->
				ele[0].lastElementChild.draggable = true
				scope.$apply()
				return

			ele.bind 'hidden.bs.collapse', ->
				console.log ele
	}
])
