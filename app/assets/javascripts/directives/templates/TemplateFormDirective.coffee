directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$rootScope', '$scope', '$routeParams', '$location', 'ReportFactory', 
	($rootScope, $scope, $routeParams, $location, ReportFactory) ->

		$scope.selectTemplate = ->
			$scope.form.allow_title = $scope.selectedTemplate.allow_title
			$scope.form.sections = $scope.selectedTemplate.sections

		$scope.saveReport = ->
			if !$scope.form.template
				$scope.form.template_id = $scope.selectedTemplate.id
			$scope.form.sections = JSON.stringify($scope.form.sections)
			if $scope.form.id
				$scope.form.$update({id: $scope.form.id}, (res)->
					$location.path("/reports/#{$scope.form.id}")
					$rootScope.$broadcast('clearreports')
				)
			else
				$scope.form.$save({}, (res)->
					$location.path("/reports/#{$scope.form.id}")
					$rootScope.$broadcast('clearreports')
				)

		$scope.deleteReport = ->
			console.log $scope.form
			$scope.form.$delete({id: $scope.form.id})
			.then((res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports"))

	]
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		templates: '='
	}
])