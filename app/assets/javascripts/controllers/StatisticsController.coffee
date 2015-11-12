controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['StatisticsService', 'TemplatesService', '$scope',
(StatisticsService, TemplatesService, $scope)->

	sv = this

	sv.templates = TemplatesService.listTemplates()

	unbindTempLoadWatch = $scope.$watch (()-> sv.templates), ((newVal, oldVal)->
		if sv.templates.length
			StatisticsService.init().then((res)->
				$.extend sv, res
				sv.graph = {name:'Column',type:'ColumnChart'}
				sv.days = 5
				sv.filteredTemplates = ->
					sv.templates.filter((template)->
						template.fields.length && !template.draft
					)
				sv.template = sv.filteredTemplates()[0]
				sv.filteredFields = ->
					sv.template.fields.filter((field)->
						'labelntext' != field.fieldtype
					)
				sv.field = sv.filteredFields()[0]
				unbindTempLoadWatch()
			)
	)

	return sv

])