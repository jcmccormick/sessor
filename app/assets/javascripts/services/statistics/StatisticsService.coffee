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

		getFieldData: ->
			deferred = $q.defer()
			sv = this
			ClassFactory.query({class: 'values_statistics', id: 'counts', field_id: sv.field.id, days: sv.days}, (res)->
				sv.field_data = res
				deferred.resolve(sv)
			)
			return deferred.promise

		showData: (graph)->
			this.data = {}
			this.data.rows = []
			this.data.cols = []
			this.options = {}
			this.options.title = this.template.name+': '+this.field.name

			n = 1
			while n < this.field_data[0].values.length
				this.data.cols.push { id: this.field_data[0].values[n].input+'-id', label: this.field_data[0].values[n].input, type: 'number' }
				n++

			console.log this.data.cols

			this.data.cols.unshift {id: 'day', label: 'Date', type: 'string'}
			

			n = 0
			while n < this.field_data.length
				this.data.rows[n] = {c: [ {v: new Date(this.field_data[n].date).format('DD-MM-YY')} ] }
				i = 0
				while i < this.field_data[n].values.length
					this.field_data[n].values[i] && this.field_data[n].values[i].input? && this.data.rows[n].c.push { v: this.field_data[n].values[i].count }
					i++
				n++

				#this.data.rows[n].c.push {v: this.field_data[n].total}
			#this.data.cols.push {id: 's', label: 'Total', type: 'number'}

			this.data.rows = $.grep this.data.rows, (row)->
				row.c.length > 1

			this.type = graph.type
			return

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