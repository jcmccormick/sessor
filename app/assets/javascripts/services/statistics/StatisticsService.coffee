services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory',
($q, ClassFactory)->

	countCols = (chart)->
		chart.colsLen = []
		n = 0
		while n < chart.data.cols.length
			chart.colsLen.push n
			n++
		chart.noTotals = angular.copy chart.colsLen
		chart.noTotals.pop()
		return

	{

		init: ->
			deferred = $q.defer()
			this.setDefaults()
			sv = this
			ClassFactory.query({class: 'values_statistics'}, (res)->
				sv.templates = res
				deferred.resolve(sv)
			)

			return deferred.promise

		setDefaults: ->
			this.data = {}
			this.view = {}
			this.options = {}
			this.options.pieHole = 0
			this.options.pieHole = 0
			this.options.legend = {}
			this.options.legend.position = 'bottom'
			this.options.legend.alignment = 'start'
			this.showTotals = true

		graphs: [
			{name:'Pie',type:'PieChart'}
			{name:'Column',type:'ColumnChart'}
			{name:'Bar',type:'BarChart'}
			{name:'Area',type:'AreaChart'}
			{name:'Line',type:'LineChart'}
			{name:'Table',type:'Table'}
		]

		getFieldData: ->
			deferred = $q.defer()
			this.options.title = this.template.name+': '+this.field.name
			sv = this
			ClassFactory.get({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days}, (res)->
				sv.data.cols = res.cols
				sv.data.rows = res.rows
				countCols(sv)
				deferred.resolve(sv)
			)
			return deferred.promise

		showDataCounts: (graph)->
			this.options.width = Math.round($(document).width()*.98)
			this.options.height = Math.round($(document).height()*.65)
			this.type = graph.type
			return

		setOptions: ->
			this.view.columns = if !this.showTotals then this.noTotals else this.colsLen

	}
])