controllers = angular.module('controllers')
controllers.controller('UserSessionsController', ['$scope', 'flash', 
($scope, flash)->
	$scope.$on('auth:login-error', (ev, reason)->
		flash.error = reason.errors[0]
	)
])