services = angular.module('services')
services.service('StatisticsService', [->
	{
	getCountOfIn: (ent, arr)->
		this.ent = []
		x = 0
		while x < arr.length
			if arr[x].template? || arr[x].section?
				jsonData = JSON.parse(arr[x].template)
				arr[x].b = $.map(jsonData, (value, index)->
					value.key = index
					return [value]
				)
				y = 0
				while y < arr[x].b.length
					z = 0
					while z < arr[x].b[y].columns.length
						q = 0
						while q < arr[x].b[y].columns[z].fields.length
							this.ent.push arr[x].b[y].columns[z].fields[q][ent]
							q++
						z++
					y++
			x++
		this.ent = this.countD(this.ent)
		return this.ent
		
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