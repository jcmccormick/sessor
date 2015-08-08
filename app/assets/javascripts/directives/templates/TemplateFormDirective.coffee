directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$route', '$rootScope', '$scope', '$location', 'Flash',
	($route, $rootScope, $scope, $location, Flash)->

		$scope.setSelectedOptions = (optionSet)->
			if $scope.form.editing
				$scope.selectedOptions = optionSet

		$scope.countColumns = (columns)->
			return new Array columns

		$scope.setTemplate = (template)->
			$scope.form = template

		$scope.selectTemplate = (template)->
			$scope.report.template_ids.push template.id
			if !$scope.report.id
				$scope.report.title = 'Untitled'
				$scope.report.$save({class: 'reports'}, (res)->
					$location.path("/reports/#{res.id}/edit")
				)
			else
				$rootScope.$broadcast('clearreports')
				$scope.report.$update({class: 'reports', id: $scope.report.id}, (res)->
					$route.reload()
				)

		$scope.saveReport = (temp)->
			if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.report.title || $scope.report.title != undefined
				Flash.create('error', 'Title must begin with a letter and only contain letters and numbers.')
			else
				$rootScope.$broadcast('clearreports')
				$scope.report.values_attributes = $scope.report.values
				$scope.report.$update({class: 'reports', id: $scope.report.id}, (res)->
					if !temp
						$location.path("/reports/#{$scope.report.id}")
				)

		$scope.deleteReport = ->
			$scope.report.$delete({class: 'reports', id: $scope.report.id}, (res)->
				$rootScope.$broadcast('clearreports')
				$location.path("/reports")
			)
	]
	templateUrl: 'directives/templates/views/form/form.html'
	restrict: 'E'
	scope:
		form: '='
		report: '='
		templates: '='
		selectedOptions: '='
	}
])