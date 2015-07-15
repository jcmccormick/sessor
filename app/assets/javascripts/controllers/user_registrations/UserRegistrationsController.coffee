controllers = angular.module('controllers')
controllers.controller('UserRegistrationsController', ['$scope', '$auth', '$location', 'Flash',
($scope, $auth, $location, Flash)->
	$scope.handleRegBtnClick = ->
		#str = $scope.registrationForm.password
		#if str.length < 8
		#	Flash.error = "Please use a password 8 or more characters long."
		#else if str.search(/\d/) == -1
		#	Flash.error = "Please include one number in your password."
		#else if str.search(/[a-zA-Z]/) == -1
		#	Flash.error = "Please include one letter in your password."
		#else if str.search(/[^a-zA-Z0-9\!\@\#\$\%\^\&\*\(\)\_\+]/) != -1
		#	Flash.error = "You may only include the following special characters: ! @ # $ % ^ & * ( ) _ +"
		#else if $scope.registrationForm.password != $scope.registrationForm.password_confirmation
		#	Flash.error = "The passwords do not match."
		#else
		$auth.submitRegistration($scope.registrationForm)
		.success((res)->
			$location.path('/desktop')
		#	Flash.success = "Account created! Welcome to Sessor."
		).error((err)->
			console.log err.data
		#	Flash.error = "There was an error creating your account. The email may already be in use. Contact support if errors persist."
		)
])