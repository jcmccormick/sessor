controllers = angular.module('controllers')
controllers.controller("EditReportController", ['$rootScope', '$auth', '$scope', '$routeParams', '$location', 'ClassFactory',
($rootScope, $auth, $scope, $routeParams, $location, ClassFactory)->
	
	$scope.report = new ClassFactory()
	$scope.report.livesave = true
	$scope.report.template_ids = []

	if $routeParams.reportId
		ClassFactory.get({class: 'reports', id: $routeParams.reportId}, (res)->
			jQuery.extend $scope.report, res
			$scope.report.templates.forEach((template)->
				$scope.report.template_ids.push template.id
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

	$scope.report.checkTemplate = (template_id)->
		if $scope.report.template_ids.indexOf(template_id) == -1 
			return true
		else
			return false
])