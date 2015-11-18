directives = angular.module('directives')
directives.directive('clerkrRegistration', ['$auth', '$location', 'Flash',
($auth, $location, Flash) ->

	validatePassword = (pass, conf)->
		msg = ''
		pass.length < 8 && msg += "Please use a password 8 or more characters long. "
		pass.search(/\d/) == -1 && msg += "Please include one number in your password. "
		pass.search(/[a-zA-Z]/) == -1 && msg += "Please include one letter in your password. "
		pass.search(/[^a-zA-Z0-9\!\@\#\$\%\^\&\*\(\)\_\+]/) != -1 && msg +="You may only include the following special characters: ! @ # $ % ^ & * ( ) _ + "
		pass != conf && msg += "The passwords do not match. "
		return msg


	{
		restrict: 'E'
		scope: true
		link: (scope, element, attrs) ->

			scope.forgForm = {}

			scope.subForg = ->
				$auth.requestPasswordReset(scope.forgForm)
				.success((res)->
					Flash.create('success', '<h3>Success! <small>Auth</small></h3><p>'+res.message+'</p>', 'customAlert')
				).error((err)->
					Flash.create('danger', '<h3>Error! <small>Auth</small></h3><p>'+err.errors+'</p>', 'customAlert')
				)

			scope.regForm = {}

			scope.subReg = ->
				msg = validatePassword(scope.regForm.password, scope.regForm.password_confirmation)

				if msg
					Flash.create('danger', '<h3>Error! <small>Auth</small></h3><p>'+msg+'</p>', 'customAlert')
				else
					$auth.submitRegistration(scope.regForm)
					.success((res)->
						$location.path('/desktop')
						Flash.create('success', "<h3>Success! <small>Auth</small></h3><p>Account created! Welcome to Clerkr.</p>", 'customAlert')
					).error((err)->
						Flash.create('danger', "<h3>Error! <small>Auth</small></h3><p>There was an error creating your account. The email may already be in use. Try again and contact support if errors persist.</p>", 'customAlert')
					)

			scope.subPass = ->
				msg = validatePassword(scope.regForm.password, scope.regForm.password_confirmation)

				if msg
					Flash.create('danger', '<h3>Error! <small>Auth</small></h3><p>'+msg+'</p>', 'customAlert')
				else
					$auth.updatePassword(scope.regForm)
					.success((res)->
						Flash.create('success', "<h3>Success! <small>Auth</small></h3><p>Your password has been updated.</p>", 'customAlert')
						scope.regForm = {}
					).error((err)->
						Flash.create('danger', '<h3>Error! <small>Auth</small></h3><p>'+err.errors+'</p>', 'customAlert')
					)
	}
])
