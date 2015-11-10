filters = angular.module('filters')
filters.filter("startFrom", [->
	return (input, start)->
		start = +start
		return input.slice start
])