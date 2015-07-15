controllers = angular.module('controllers')
controllers.controller('UserSessionsController', ['$scope', 'Flash', 
($scope, Flash)->
	$scope.$on('auth:login-error', (ev, reason)->
		#flash.error = reason.errors[0]
	)
])