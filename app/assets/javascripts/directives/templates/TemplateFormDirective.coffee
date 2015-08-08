directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$route', '$rootScope', '$scope', '$routeParams', '$location', 'Flash', 'ClassFactory', 
	($route, $rootScope, $scope, $routeParams, $location, Flash, ClassFactory)->

		$scope.countColumns = (columns)->
			return new Array columns

		$scope.selectTemplate = (template)->
			$scope.form.template_ids.push template.id
			if !$scope.form.id
				$scope.form.title = "Untitled"
				$scope.form.$save({class: 'reports'}, (res)->
					$location.path("/reports/#{res.id}/edit")
				)
			else
				$rootScope.$broadcast('clearreports')
				$scope.form.$update({class: 'reports', id: $scope.form.id}, (res)->
					$route.reload()
				)

		$scope.saveReport = (temp)->
			if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.form.title
				Flash.create('error', 'Title must begin with a letter and only contain letters and numbers.')
			else
				$rootScope.$broadcast('clearreports')
				$scope.form.values_attributes = $scope.form.values
				$scope.form.$update({class: 'reports', id: $scope.form.id}, (res)->
					if !temp
						$location.path("/reports/#{$scope.form.id}")
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