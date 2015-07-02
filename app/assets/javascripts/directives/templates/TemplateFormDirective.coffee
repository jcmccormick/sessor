directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
	{
	controller: ['$rootScope', '$scope', '$routeParams', '$location', 'Flash', 'ReportFactory', 
	($rootScope, $scope, $routeParams, $location, Flash, ReportFactory) ->

		$scope.selectTemplate = ->
			$scope.form.allow_title = $scope.selectedTemplate.allow_title
			$scope.form.sections = $scope.selectedTemplate.sections

		$scope.saveReport = ->
			tempCopy = new ReportFactory()
			angular.copy $scope.form, tempCopy
			if !tempCopy.template
				tempCopy.template_id = $scope.selectedTemplate.id
			tempCopy.sections = JSON.stringify(tempCopy)
			if tempCopy.id
				tempCopy.$update({id: tempCopy.id}, (res)->
					$location.path("/reports/#{tempCopy.id}")
					$rootScope.$broadcast('clearreports')
				)
			else
				tempCopy.$save({}, (res)->
					$location.path("/reports/#{tempCopy.id}")
					$rootScope.$broadcast('clearreports')
				).catch((err)->
					errors = '<h3>'+err.data.pluralerrors+'</h3><ul>'
					err.data.errors.forEach((error)->
						errors += '<li>'+error+'</li>'
					)
					errors += '</ul>'
					Flash.create('error', errors)
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