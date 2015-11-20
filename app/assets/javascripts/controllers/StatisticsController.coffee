controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['localStorageService', 'StatisticsService', 'TemplatesService', '$scope',
(localStorageService, StatisticsService, TemplatesService, $scope)->

	sv = this
	$.extend sv, StatisticsService
	sv.templates = localStorageService.get('_cst')
	sv.days = 5
	sv.graph = sv.graphs[1]
	sv.chart = {}
	sv.chart.data = {}
	sv.chart.view = {}
	sv.chart.type = sv.graph.type
	sv.chart.showTotals = true
	sv.chart.options = {}
	sv.chart.options.pieHole = 0
	sv.chart.options.legend = {}
	sv.chart.options.legend.position = 'bottom'
	sv.chart.options.legend.alignment = 'start'

	unbindTemplateWatch = $scope.$watch (()-> sv.orderedTemplates), (newVal, oldVal)->
		if sv.orderedTemplates
			sv.template = sv.orderedTemplates[0]
			sv.checker()
			unbindTemplateWatch()

	unbindFieldWatch = $scope.$watch (()-> sv.filteredFields), (newVal, oldVal)->
		if sv.filteredFields && newVal != oldVal
			sv.field = sv.filteredFields[0]
			sv.field && sv.update()
			unbindFieldWatch()

	sv.checker = ->
		if !sv.template.fields
			TemplatesService.queryTemplate(sv.template.id, true).then((res)->
				$.extend sv.template, res
			)

	sv.update = ->
		sv.showDataCounts(sv).then((res)->
			sv.chart = res
		)

	sv.setOptions = ->
		sv.chart.view.columns = if !sv.chart.showTotals then sv.chart.noTotals else sv.chart.colsLen

	$(->
		$('.form-header').css('min-height': (50+$('.form-specs').height())+'px')
		$('.form-specs').on 'shown.bs.collapse', ->
			$('.form-header').css('min-height': (50+$(this).height())+'px')
	)
	sv.checkSpec = ->
		$('.form-specs').hasClass('in') && $('.form-header').css('min-height': '50px')
		return true

	return sv

])