do ->
	'use strict'

	startFrom = ->
		(input, start)->
			start = +start
			input.slice start

	angular.module('clerkr').filter("startFrom", startFrom)