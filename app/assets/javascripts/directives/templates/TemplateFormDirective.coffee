directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		report: '='
	controller: ['$scope', ($scope)->
		$scope.columnsArray = (columns)->
			new Array columns

		$scope.setBreadcrumb = (template)->
			$scope.form = template

	]}
])