controllers = angular.module('controllers')
controllers.controller('UserRegistrationsController', ['$scope', '$auth', '$location', 'flash',
($scope, $auth, $location, flash)->
	$scope.handleRegBtnClick = ->
		str = $scope.registrationForm.password
		if str.length < 8
			flash.error = "Please use a password 8 or more characters long."
		else if str.search(/\d/) == -1
			flash.error = "Please include one number in your password."
		else if str.search(/[a-zA-Z]/) == -1
			flash.error = "Please include one letter in your password."
		else if str.search(/[^a-zA-Z0-9\!\@\#\$\%\^\&\*\(\)\_\+]/) != -1
			flash.error = "You may only include the following special characters: ! @ # $ % ^ & * ( ) _ +"
		else if $scope.registrationForm.password != $scope.registrationForm.password_confirmation
			flash.error = "The passwords do not match."
		else
			$auth.submitRegistration($scope.registrationForm)
			.success((res)->
				$location.path('/desktop')
				flash.success = "Account created! Welcome to Sessor."
			).error((err)->
				console.log err.data
				flash.error = "There was an error creating your account. The email may already be in use. Contact support if errors persist."
			)
])