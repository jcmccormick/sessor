directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
		templateUrl: 'directives/pages/views/form/form.html'
		restrict: 'E'
		scope:
			form: '='
			report: '='
		controller: ['$scope', ($scope)->
			
			$scope.columnsArray = (columns)->
				new Array columns

			$scope.setBreadcrumb = (template)->
				$scope.form = template

			$scope.gridWidth = ->
				section_columns = ($.map $scope.form.sections, (x)-> x.c)
				max = Math.max.apply(Math, section_columns)
				return parseInt(max, 10)

		]
	}
])