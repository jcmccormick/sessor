services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory', 'Flash',
($q, ClassFactory, Flash)->

	countCols = (chart)->
		chart.colsLen = []
		n = 0
		while n < chart.data.cols.length
			chart.colsLen.push n
			n++
		chart.noTotals = angular.copy chart.colsLen
		chart.noTotals.pop()
		chart.view.columns = chart.colsLen
		return

	{
		showDataCounts: (sv)->
			deferred = $q.defer()
			ClassFactory.get({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days}, (res)->
				!res.rows.length && Flash.create('danger', '<h3>Error! <small>No data</small></h3><p>There is no data for the selected field.</p>', 'customAlert')
				sv.chart.data.cols = res.cols
				sv.chart.data.rows = res.rows
				countCols(sv.chart)
				sv.chart.options.title = sv.template.name+': '+(sv.field.o.name || sv.field.o.placeholder)
				sv.chart.options.width = Math.round($(document).width()*.85)
				sv.chart.options.height = Math.round($(document).height()*.6)
				deferred.resolve(sv.chart)
			)
			return deferred.promise

		graphs: [
			{name:'Pie',type:'PieChart'}
			{name:'Column',type:'ColumnChart'}
			{name:'Bar',type:'BarChart'}
			{name:'Area',type:'AreaChart'}
			{name:'Line',type:'LineChart'}
			{name:'Table',type:'Table'}
		]

	}
])