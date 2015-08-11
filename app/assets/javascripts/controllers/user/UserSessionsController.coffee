controllers = angular.module('controllers')
controllers.controller('UserSessionsController', ['$location', '$scope', 'Flash', 
($location, $scope, Flash)->
	$scope.$on('auth:login-error', (ev, reason)->
		Flash.create('danger', reason.errors[0])
	)
	$scope.$on('auth:logout-begin', (ev, reason)->
		$location.path('/')
	)
])