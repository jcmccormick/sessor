controllers = angular.module('controllers')
controllers.controller("StatisticsController",  ['StatisticsService',
(StatisticsService)->

	sv = this

	StatisticsService.init().then((res)->
		$.extend sv, res
	)

	return sv

])