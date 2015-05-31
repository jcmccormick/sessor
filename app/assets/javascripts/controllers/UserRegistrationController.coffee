controllers = angular.module('controllers')
controllers.controller('UserRegistrationController', ['$scope', '$auth', ($scope, $auth)->
	$scope.handleRegBtnClick = ->
		$auth.submitRegistration($scope.registrationForm)
			.then(->
				$auth.submitLogin({
					email: $scope.registrationForm.email,
					password: $scope.registrationForm.password
				})
			)
])