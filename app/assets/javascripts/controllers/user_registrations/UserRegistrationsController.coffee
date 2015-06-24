controllers = angular.module('controllers')
controllers.controller('UserRegistrationsController', ['$scope', '$auth', 'flash',
($scope, $auth, flash)->
	$scope.$on('auth:registration-email-error', (ev, reason) ->
		flash.error = reason.errors[0]
		return
	)
	$scope.handleRegBtnClick = ->
		if $scope.registrationForm.password.length < 8
			flash.error = "Please try again with a password that is 8 or more characters long."
			return
		else
			$auth.submitRegistration($scope.registrationForm)
])