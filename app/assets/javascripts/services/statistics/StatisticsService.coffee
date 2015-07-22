services = angular.module('services')
services.service('StatisticsService', [->
	{
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