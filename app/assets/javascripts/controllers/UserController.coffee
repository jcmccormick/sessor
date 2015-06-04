controllers = angular.module('controllers')
controllers.controller('UserController', ['$auth', '$scope', '$location', ($auth, $scope, $location)->
	
	$scope.$on('auth:login-error', (ev, reason)->
		$scope.error = reason.errors[0]
	)
	$scope.handleSignOut = ->
		$auth.signOut()
			.then(()->
				$location.path('/')
			)

	$scope.handleForgotPass = ->
		$auth.requestPasswordReset({
			email: $scope.fpemail
		})
])