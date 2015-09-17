services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory',
($q, ClassFactory)->

	countD = (arr)->
		arr.sort()
		prev = undefined
		a = []
		b = []
		i = 0
		while i < arr.length
			if arr[i] != prev
				a.push arr[i]
				b.push 1
			else
				b[b.length - 1]++
			prev = arr[i]
			i++
		[a,	b]

	{

		init: (sv)->
			deferred = $q.defer()
			sv.listFields = this.listFields
			sv.showData = this.showData
			sv.graphTypes = this.graphTypes

			sv.needLegend = true
			sv.type = 'BarChart'
			sv.data = {}
			sv.data.cols = [
				{id: 't', label: 'Name', type: 'string'}
				{id: 's', label: 'Count', type: 'number'}
			]

			sv.templates = []
			sv.fields = []
			sv.search = []

			sv.search.key = 'name'
			sv.search.date = {}
			sv.search.time = {}

			ClassFactory.query({class: 'values_statistics'}, (res)->
				for template in res
					sv.templates.push template
				deferred.resolve(sv)
			)

			return deferred.promise

		listFields: (template, sv)->
			deferred = $q.defer()
			ClassFactory.query({class: 'fields', template_id: template.id, stats: true}, (res)->
				sv.fields = res
				deferred.resolve(sv)
			)
			return deferred.promise

		showData: (field, sv)->
			deferred = $q.defer()
			sv.data.rows = []
			sv.values = []
			sv.options = {
				'title': field.name
			}

			ClassFactory.query({class: 'values', field_id: field.id, stats: true}, (res)->
				for value in res
					sv.values.push value.input

				sv.all_data = countD(sv.values)

				i = 0
				while i < sv.all_data[0].length
					if sv.all_data[0][i] != null
						sv.data.rows.push {c: [
							{v:sv.all_data[0][i]}
							{v:sv.all_data[1][i]}
						]}
					i++

				deferred.resolve(sv)
			)

			return deferred.promise

		graphTypes: ['PieChart','BarChart','ColumnChart']

	}
])