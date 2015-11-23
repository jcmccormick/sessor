controllers = angular.module('controllers')
controllers.controller('UsersController', ['$scope', '$auth', '$location', 'Flash',
($scope, $auth, $location, Flash)->
	
	$scope.$on 'auth:logout-success', ->
		console.log 'what'

	$scope.handleRegBtnClick = ->
		str = $scope.regForm.password
		if str.length < 8
			Flash.create('danger',"Please use a password 8 or more characters long.", 'customAlert')
		else if str.search(/\d/) == -1
			Flash.create('danger', "Please include one number in your password.", 'customAlert')
		else if str.search(/[a-zA-Z]/) == -1
			Flash.create('danger', "Please include one letter in your password.", 'customAlert')
		else if str.search(/[^a-zA-Z0-9\!\@\#\$\%\^\&\*\(\)\_\+]/) != -1
			Flash.create('danger', "You may only include the following special characters: ! @ # $ % ^ & * ( ) _ +", 'customAlert')
		else if $scope.regForm.password != $scope.regForm.password_confirmation
			Flash.create('danger', "The passwords do not match.", 'customAlert')
		else
			$auth.submitRegistration($scope.regForm)
			.success((res)->
				$location.path('/desktop')
				Flash.create('success', "Account created! Welcome to Clerkr.", 'customAlert')
			).error((err)->
				Flash.create('danger', "There was an error creating your account. The email may already be in use. Try again and contact support if errors persist.", 'customAlert')
			)

])