services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory',
($q, ClassFactory)->



	{

		init: ->
			deferred = $q.defer()
			sv = this

			ClassFactory.query({class: 'values_statistics'}, (res)->
				sv.templates = res
				deferred.resolve(sv)
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

		getFieldData: ->
			deferred = $q.defer()
			sv = this
			ClassFactory.query({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days}, (res)->
				console.log res
				sv.field_data = res
				deferred.resolve(sv)
			)
			return deferred.promise

		showDataCounts: (graph)->
			this.data = {}
			this.data.rows = []
			this.data.cols = []
			this.options = {}
			this.options.pieHole = 0
			this.options.title = this.template.name+': '+this.field.name

			# Examine first row of returned data (this.field_data) to extract
			# and create table columns based on unique value inputs 
			n = 0
			while n < this.field_data[0].values.length
				this.data.cols.push { id: this.field_data[0].values[n].input+'-id', label: this.field_data[0].values[n].input, type: 'number' }
				n++

			# append Date column to the beginning of table
			this.data.cols.unshift {id: 'day', label: 'Date', type: 'string'}
			
			n = 0
			while n < this.field_data.length
				# add Date data for each row
				this.data.rows[n] = {c: [ {v: new Date(this.field_data[n].date).format('MM/DD/YY')} ] }
				i = 0
				while i < this.field_data[n].values.length
					# add frequency count for each value.input column
					this.field_data[n].values[i] && this.field_data[n].values[i].input? && this.data.rows[n].c.push { v: this.field_data[n].values[i].count }
					i++
				# Next 2 operations add a Total column to the end of the chart which
				# totals the number of counts per day
				graph.type == 'Table' && this.data.rows[n].c.push {v: this.field_data[n].total}
				n++
			graph.type == 'Table' && this.data.cols.push {id: 's', label: 'Total', type: 'number'}

			# remove any days that have absolutely no data
			#this.data.rows = $.grep this.data.rows, (row)->
			#	row.c.length > 1

			this.type = graph.type
			return

	}
])