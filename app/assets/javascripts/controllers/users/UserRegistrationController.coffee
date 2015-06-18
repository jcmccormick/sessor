controllers = angular.module('controllers')
controllers.controller('UserRegistrationController', ['$scope', '$auth', '$location', 'flash', ($scope, $auth, $location, flash)->
	$scope.$on('auth:registration-email-error', (ev, reason) ->
		$scope.error = reason.errors[0]
		return
	)
	allowed_emails= ['sean.d.potts@gmail.com', 'benmccormickmedia@gmail.com', 'joe.c.mccormick@gmail.com', 'knightrage@gmail.com', 'gardnecl@gmail.com', 'mccormickcharlie@hotmail.com', 'happytogether1954@gmail.com']
	$scope.handleRegBtnClick = ->
		$('#userRegistrationModal').modal('toggle')
		i = 0
		while i < allowed_emails.length
			if $scope.registrationForm.email == allowed_emails[i]
				allowed = true
			i++

		if $scope.registrationForm.password.length < 8
			flash.error = "Please try again with a password that is 8 or more characters long."
			return
		if !allowed
			flash.error = "Sorry, it looks like you're not on the list."
		else
			$auth.submitRegistration($scope.registrationForm)
				.then(->
					$auth.submitLogin({
						email: $scope.registrationForm.email,
						password: $scope.registrationForm.password
					}).then((res)->
						flash.success = "Account created! Welcome to Sessor."
					).catch((err)->
						flash.error = "There was an issue registering your account. Make sure to meet all the requirements of the form."
					)
				)
])