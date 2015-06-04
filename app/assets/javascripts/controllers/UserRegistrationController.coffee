controllers = angular.module('controllers')
controllers.controller('UserRegistrationController', ['$scope', '$auth', '$location', 'flash', ($scope, $auth, $location, flash)->
	$scope.$on('auth:registration-email-error', (ev, reason) ->
		$scope.error = reason.errors[0]
		return
	)
	allowed_emails= ['sean.d.potts@gmail.com', 'benmccormickmedia@gmail.com', 'joe.c.mccormick@gmail.com', 'knightrage@gmail.com']
	$scope.handleRegBtnClick = ->
		i = 0
		console.log allowed_emails.length
		while i < allowed_emails.length
			if $scope.registrationForm.email == allowed_emails[i]
				allowed = true
			i++

		if !allowed
			$location.path('/')
			flash.error = "Sorry, it looks like you're not on the list."
		else
			$auth.submitRegistration($scope.registrationForm)
				.then(->
					$auth.submitLogin({
						email: $scope.registrationForm.email,
						password: $scope.registrationForm.password
					})
				)
])