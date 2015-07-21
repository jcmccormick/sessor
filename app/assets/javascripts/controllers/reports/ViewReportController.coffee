controllers = angular.module('controllers')
controllers.controller('ViewReportController', ['$scope', '$routeParams', 'ClassFactory',
($scope, $routeParams, ClassFactory)->
	ClassFactory.get({class: 'reports', id: $routeParams.reportId}, (res)->
		$scope.report = res
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
])