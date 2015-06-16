services = angular.module('services')
services.service('StatisticsService', [->
	{
	getCountOfIn: (ent, reports, callback)->
		collection = []
		#console.log reports
		reports.forEach (obj) ->
			obj.sections and obj.sections.forEach((section) ->
				section.columns and section.columns.forEach((column) ->
					column.fields and column.fields.forEach((field) ->
						if field[ent]? then collection.push field[ent]
						return
					)
					return
				)
				return
			)
			return
		collection = this.countD(collection)
		callback(collection)

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