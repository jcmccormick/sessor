controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['StatisticsService',
(StatisticsService)->

	sv = this

	StatisticsService.init(sv).then((res)->
		sv = res
	)

	return sv

])