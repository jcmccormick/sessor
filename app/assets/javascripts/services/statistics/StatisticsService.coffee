services = angular.module('services')
services.service('StatisticsService', [->
	{
	getCountOfIn: (ent, report, callback)->
		this.ent = []
		x = 0
		while x < report.length
			if report[x].template? || report[x].section?
				jsonData = JSON.parse(report[x].template)
				report[x].sections = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				y = 0
				while y < report[x].sections.length
					z = 0
					while z < report[x].sections[y].columns.length
						q = 0
						while q < report[x].sections[y].columns[z].fields.length
							this.ent.push report[x].sections[y].columns[z].fields[q][ent]
							q++
						z++
					y++
			x++
		this.ent = this.countD(this.ent)
		callback(this.ent)

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
#
#
#					c = 0
#					while c < a[x].b[i].c[b].d.length
#						$scope.labels.push a[x].b[i].c[b].d[c].type
#						$scope.values.push a[x].b[i].c[b].d[c].value
#						c++
])