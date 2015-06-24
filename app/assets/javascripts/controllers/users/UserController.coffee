controllers = angular.module('controllers')
controllers.controller('UserController', ['$auth', '$scope', '$location', '$window', 'flash', 
($auth, $scope, $location, $window, flash)->
	
	$scope.$on('auth:login-success', ->
		flash.success = "Welcome " + $auth.user.uid
		$location.path('/desktop/')
		$window.location.reload()
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
			document.cookie = 'auth_headers' + '=; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
			flash.success = "You have been signed out."
			$location.path('/')
		)
		

	$scope.handleForgotPass = (email)->
		console.log email
		$auth.requestPasswordReset(email).then((res)-> console.log res.data).catch((err)-> console.log err.data)
])