controllers = angular.module('controllers')
controllers.controller('UserSessionsController', ['$scope', 'Flash', 
($scope, Flash)->
	$scope.$on('auth:login-error', (ev, reason)->
		Flash.create('danger', reason.errors[0], 'customAlert')
	)
])