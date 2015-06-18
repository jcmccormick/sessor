directives = angular.module('directives')
directives.directive('insertCanvas', ['$parse',
($parse)->

	configureCanvasDisplay = (scope, elem, attrs)->
		elem.attr('id', scope.graphtype)
		elem.attr('class', 'chart chart-'+scope.graphtype)
		elem.append(elem)

	{	
		priority: 1001
		scope: '='
		link: configureCanvasDisplay
	}
])