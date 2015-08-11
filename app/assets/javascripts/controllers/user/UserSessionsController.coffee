controllers = angular.module('controllers')
controllers.controller('UserSessionsController', ['$rootScope', 'Flash', 
($scope, Flash)->
	$scope.$on('auth:login-error', (ev, reason)->
		Flash.create('danger', reason.errors[0])
	)
])