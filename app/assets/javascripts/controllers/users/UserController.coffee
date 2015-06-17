controllers = angular.module('controllers')
controllers.controller('UserController', ['$auth', '$scope', '$location', 'flash', 
($auth, $scope, $location, flash)->
	
	$scope.$on('auth:login-success', ->
		$location.path('/desktop/')
		return
	)
	$scope.$on('auth:login-error', (ev, reason)->
		flash.error = reason.errors[0]
	)
	$scope.$on('auth:invalid', ->
		flash.error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
		$location.path('/')
		return
	)
	$scope.handleSignOut = ->
		$auth.signOut()
		.then(()->
			flash.success = "You have been signed out."
			$location.path('/')
		)
		

	$scope.handleForgotPass = (email)->
		console.log email
		$auth.requestPasswordReset(email).then((res)-> console.log res.data).catch((err)-> console.log err.data)
])