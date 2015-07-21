directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$rootScope', '$scope', '$routeParams', '$location', 'Flash', 'ClassFactory', 
	($rootScope, $scope, $routeParams, $location, Flash, ClassFactory) ->

		$scope.selectTemplate = ->
			$scope.form.template_id = $scope.selectedTemplate.id
			$scope.form.title = "Untitled"
			$scope.form.$save({class: 'reports'}, (res)->
				$location.path("/reports/#{res.id}/edit")
			)

		$scope.saveReport = ->
			$scope.form.values_attributes = $scope.form.values
			$scope.form.$update({class: 'reports', id: $scope.form.id}, (res)->
				$location.path("/reports/#{$scope.form.id}")
				$rootScope.$broadcast('clearreports')
			)

		$scope.deleteReport = ->
			$scope.form.$delete({class: 'reports', id: $scope.form.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)

	]
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		templates: '='
	}
])