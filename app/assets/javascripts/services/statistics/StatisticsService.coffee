services = angular.module('services')
services.service('StatisticsService', [->
	{
	getCountOfIn: (query, reports, callback)->
		key = query.substr(0,query.indexOf(' '))
		searchedField = query.substr(query.indexOf(' ')+1)
		collection = []
		fieldData = []
		console.log key
		console.log searchedField
		reports.forEach (obj) ->
			obj.sections and obj.sections.forEach((section) ->
				section.columns and section.columns.forEach((column) ->
					column.fields and column.fields.forEach((field) ->
						collection.push field[key]
						if field[key] == searchedField
							fieldData.push field.value
						return
					)
					return
				)
				return
			)
			return
		fieldData = this.countD(fieldData)
		collection = this.countD(collection)
		callback(collection, fieldData)

	countD: (arr)->
		a = []
		b = []
		prev = undefined
		arr.sort()
		i = 0
		while i < arr.length
			if arr[i] != prev
				a.push arr[i]
				b.push 1
			else
				b[b.length - 1]++
			prev = arr[i]
			i++
		[
			a
			b
		]
	}
])