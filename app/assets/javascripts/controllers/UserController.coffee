controllers = angular.module('controllers')
controllers.controller('UserController', ['$scope', ($scope)->
	$scope.$on('auth:login-error', (ev, reason)->
		$scope.error = reason.errors[0]
	)
])