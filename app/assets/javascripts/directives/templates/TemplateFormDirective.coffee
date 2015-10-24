directives = angular.module('directives')
directives.directive('templateFormDirective',[()->

	$(document).on 'scroll', (->
		$(this).scrollTop() > 1 && $('.form-header').addClass('affix') && $('.view-frame').css('top':'100px')
		$(this).scrollTop() <= 1 && $('.form-header').removeClass('affix') && $('.view-frame').css('top':'50px')
	)

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