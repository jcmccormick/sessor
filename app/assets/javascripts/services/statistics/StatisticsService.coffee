services = angular.module('services')
services.service('StatisticsService', ['$q', 'ClassFactory',
($q, ClassFactory)->

	# Takes an array of values and returns [[labels],[counts]]
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
			sv.showOptions = true
			sv.templates = []
			sv.fields = undefined
			sv.search = []
			sv.type = 'PieChart'
			sv.data = {}
			sv.options = {is3D:true}

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
			sv.options.title = template.name+': '
			sv.template = template
			deferred = $q.defer()
			ClassFactory.query({class: 'fields', template_id: template.id, stats: true}, (res)->
				sv.fields = res
				deferred.resolve(sv)
			)
			return deferred.promise

		showData: (field, sv)->
			deferred = $q.defer()
			sv.field = field
			sv.data.rows = []
			sv.values = []

			ClassFactory.query({class: 'values', field_id: field.id, stats: true}, (res)->
				console.log res
				stDate = sv.search.startDate || res[res.length-1].created_at
				enDate = sv.search.endDate || res[0].created_at

				console.log stDate

				for value in res
					if value.input? && (new Date(value.created_at) >= new Date(stDate) && new Date(value.created_at) <= new Date(enDate))
						sv.values.push value.input

				sv.all_data = countD(sv.values)

				n = 0
				i = 0
				while i < sv.all_data[0].length
					sv.data.rows.push {c: [
						{v:sv.all_data[0][i]}
						{v:sv.all_data[1][i]}
					]}
					n += sv.all_data[1][i]
					i++

				sv.options.title += field.name+' (n='+n+')'

				deferred.resolve(sv)
			)

			return deferred.promise

		graphTypes: ['PieChart','ColumnChart','BarChart']

	}
])