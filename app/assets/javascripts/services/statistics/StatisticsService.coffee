services = angular.module('services')
services.service('StatisticsService', [->
	{
	getCountOfIn: (query, reports, callback)->
		collection = []
		fieldData = []
		optionLabels = []
		console.log query.field
		console.log query.key
		reports.forEach (obj) ->
			if obj.template_name == query.template
				obj.sections and obj.sections.forEach((section) ->
					section.columns and section.columns.forEach((column) ->
						column.fields and column.fields.forEach((field) ->
							collection.push field[query.key]
							if field[query.key] == query.field
								fieldData.push field.value
								if field.options
									field.options.forEach((option)->
										optionLabels.push option.name
									)
							return
						)
						return
					)
					return
				)
			return
		fieldData = this.countD(fieldData)
		collection = this.countD(collection)
		callback(collection, fieldData, optionLabels)

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