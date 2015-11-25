do ->
	'use strict'

	StatisticsController = (googleChartApiPromise, localStorageService, StatisticsService, TemplatesService, $scope)->

		sv = this
		$.extend sv, StatisticsService
		sv.templates = localStorageService.get('_cst')
		sv.days = 5
		sv.graph = sv.graphs[1]
		sv.chart = {}
		sv.chart.data = {}
		sv.chart.view = {}
		sv.chart.type = sv.graph.type

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
			sv.chartEditor && sv.chartEditor.closeDialog()
			sv.showDataCounts(sv)

		$(->
			$('.form-header').css('min-height': (50+$('.form-specs').height())+'px')
			$('.form-specs').on 'shown.bs.collapse', ->
				$('.form-header').css('min-height': (50+$(this).height())+'px')
		)
		sv.checkSpec = ->
			$('.form-specs').hasClass('in') && $('.form-header').css('min-height': '50px')
			return true
		return sv

	StatisticsController.$inject = ['googleChartApiPromise', 'localStorageService', 'StatisticsService', 'TemplatesService', '$scope']

	angular.module('clerkr').controller("StatisticsController", StatisticsController)