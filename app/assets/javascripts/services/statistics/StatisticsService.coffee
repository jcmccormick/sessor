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
			sv.templates = []
			sv.fields = undefined
			sv.search = []
			sv.type = 'PieChart'
			sv.data = {}
			sv.data.cols = [
				{id: 't', label: 'Name', type: 'string'}
				{id: 's', label: 'Count', type: 'number'}
			]

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

			ClassFactory.query({class: 'values', field_id: field.id, stats: true}, (res)->
				for value in res
					sv.values.push value.input

				sv.all_data = countD(sv.values)

				n = 0
				i = 0
				while i < sv.all_data[0].length
					if sv.all_data[0][i] != null
						sv.data.rows.push {c: [
							{v:sv.all_data[0][i]+' ('+sv.all_data[1][i]+')'}
							{v:sv.all_data[1][i]}
						]}
						n += sv.all_data[1][i]
					i++

				sv.options = {
					'title': field.name + ' (n=' + n + ')'
				}

				deferred.resolve(sv)
			)

			return deferred.promise

		graphTypes: ['PieChart','ColumnChart','BarChart']

	}
])