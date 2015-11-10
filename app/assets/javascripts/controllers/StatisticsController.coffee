controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['StatisticsService', 'TemplatesService', '$scope',
(StatisticsService, TemplatesService, $scope)->

	sv = this

	sv.templates = TemplatesService.listTemplates()

	unbindTempLoadWatch = $scope.$watch (()-> sv.templates), ((newVal, oldVal)->
		if sv.templates.length
			console.log sv.templates
			StatisticsService.init().then((res)->
				$.extend sv, res
				sv.days = 5
				sv.template = sv.templates[0]
				sv.field = sv.template.fields[0]
				unbindTempLoadWatch()
			)
	)

	return sv

])