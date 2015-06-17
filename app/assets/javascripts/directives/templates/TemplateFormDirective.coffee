directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$rootScope', '$scope', '$routeParams', '$location', 'ReportFactory', 
	($rootScope, $scope, $routeParams, $location, ReportFactory) ->
		$scope.saveReport = ->
			$scope.form.template = JSON.stringify($scope.form.sections)
			console.log $scope.form
			if $scope.form.id
				$scope.form.$update({id: $scope.form.id}, (res)->
					$location.path("/reports/#{$scope.form.id}")
					$rootScope.$broadcast('clearreports')
				)
			else
				$scope.form.$save({}, (res)->
					console.log 'saved'
					$location.path("/reports/#{$scope.form.id}")
					$rootScope.$broadcast('clearreports')
				).catch((err)-> console.log err.data)

		$scope.deleteReport = ()->
			console.log $scope.form
			$scope.form.$delete({id: $scope.form.id})
			.then((res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports"))
	]
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope: form: '='
	}
])