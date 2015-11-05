services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory',
($q, ClassFactory)->

	countData = (chart)->
		chart.data.rows = []
		chart.data.cols = []
		# Examine first row of returned data (chart.data_days) to extract
		# and create table columns based on unique value inputs 
		n = 0
		while n < chart.data_days.length
			for value in chart.data_days[n].values
				!$.grep(chart.data.cols, (col)->
					col.label == value.input
				).length && chart.data.cols.push { id: value.input+'-id', label: value.input, type: 'number' }
			n++

		# append Date column to the beginning of table
		chart.data.cols.unshift {id: 'day', label: 'Date', type: 'string'}
		
		n = 0
		while n < chart.data_days.length
			# add Date data for each row
			chart.data.rows[n] = {c: [ {v: new Date(chart.data_days[n].date).format('MM/DD/YY')} ] }
			i = 0
			while i < chart.data.cols.length-1
				# add frequency count for each value.input column
				(chart.data_days[n].values[i]? && chart.data.rows[n].c.push { v: chart.data_days[n].values[i].count }) || chart.data.rows[n].c.push { v: 0 }
				i++

			# Next 2 operations add a Total column to the end of the chart which
			# totals the number of counts per day
			chart.data.rows[n].c.push {v: chart.data_days[n].total}
			n++
		chart.data.cols.push {id: 's', label: 'Total', type: 'number'}


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
			this.options.interpolateNulls = true
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
			ClassFactory.query({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days}, (res)->
				sv.data_days = res
				countData(sv)
				deferred.resolve(sv)
			)
			return deferred.promise

		showDataCounts: (graph)->
			this.options.width = Math.round($(document).width()*.98)
			this.options.height = Math.round($(document).height()*.65)

			this.type = graph.type

			# remove any days that have absolutely no data
			#this.data.rows = $.grep this.data.rows, (row)->
			#	row.c.length > 1

			return

		setOptions: ->
			this.view.columns = if !this.showTotals then this.noTotals else this.colsLen

	}
])