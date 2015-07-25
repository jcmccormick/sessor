directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$route', '$rootScope', '$scope', '$routeParams', '$location', 'Flash', 'ClassFactory', 
	($route, $rootScope, $scope, $routeParams, $location, Flash, ClassFactory)->

		$scope.selectTemplate = (template)->
			$rootScope.$broadcast('clearreports')
			$scope.form.template_ids.push template.id
			if !$scope.form.id
				$scope.form.title = "Untitled"
				$scope.form.$save({class: 'reports'}, (res)->
					$location.path("/reports/#{res.id}/edit")
				)
			else
				$scope.form.$update({class: 'reports', id: $scope.form.id}, (res)->
					console.log res
					$route.reload()
				)

		$scope.saveReport = (temp)->
			console.log $scope.form.values
			$scope.form.values_attributes = $scope.form.values
			$scope.form.$update({class: 'reports', id: $scope.form.id}, (res)->
				if !temp
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