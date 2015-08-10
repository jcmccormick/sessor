directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$route', '$rootScope', '$scope', '$location', 'Flash',
	($route, $rootScope, $scope, $location, Flash)->

		$scope.setSelectedOptions = (optionSet)->
			if $scope.form.editing
				$scope.form.selectedOptions = optionSet

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
			errors = ''
			if !/^[a-zA-Z]*[a-zA-Z][a-zA-Z0-9_ ]*$/.test $scope.report.title
				errors += '<p>Title must begin with a letter and only contain letters and numbers.</p>'
			if $scope.myForm.$invalid
				if $scope.myForm.$error.required
					console.log $scope.myForm.$error
					required = []
					$scope.myForm.$error.required.forEach((err)->
						required.push '<li>- '+err.$name+'</li>'
					)
					required = required.filter((item, i, ar)-> return required.indexOf(item) == i ).join('')
					errors += 'The following fields are required:<ul class="list-unstyled">'+required+'</ul>'
			if errors != '' then Flash.create('danger', errors)
			else
				$rootScope.$broadcast('clearreports')
				$scope.report.values_attributes = $scope.report.values
				$scope.report.$update({class: 'reports', id: $scope.report.id}, (res)->
					if temp != true
						$location.path("/reports/#{$scope.report.id}")
					Flash.create('success', '<h3>Report saved!</h3>')
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