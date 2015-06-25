controllers = angular.module('controllers')
controllers.controller('UserRegistrationsController', ['$scope', '$auth', 'flash',
($scope, $auth, flash)->
	$scope.$on('auth:registration-email-error', (ev, reason) ->
		flash.error = reason.errors[0]
		return
	)
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
		else
			$auth.submitRegistration($scope.registrationForm)
])