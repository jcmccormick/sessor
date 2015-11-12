filters = angular.module('filters')
filters.filter("filteredPageNum", [->
	(input)->
		Math.ceil(input)
])