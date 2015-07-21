controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$auth', '$scope', '$routeParams', '$location', 'ClassFactory',
($rootScope, $auth, $scope, $routeParams, $location, ClassFactory)->

	$scope.report = new ClassFactory()
	$scope.report.livesave = true

	if $routeParams.reportId
		ClassFactory.get({class: 'reports', id: $routeParams.reportId}, (res)->
			jQuery.extend $scope.report, res
			$scope.report.templates.forEach((template)->
				template.sections.forEach((section)->
					section.columns.forEach((column)->
						column.fields.forEach((field)->
							field.values = $scope.report.values.filter((obj)->
								return obj.field_id == field.id
							)
						)
					)
				)
			)
		)
	else
		ClassFactory.query({class: 'templates'}, (res)->
			$scope.templates = res
		)
])