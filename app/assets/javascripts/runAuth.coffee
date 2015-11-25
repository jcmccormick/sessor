# do ->
# 	'use strict'

# 	runAuth = ($auth, $location, $rootScope, AuthorizationService)->
# 		console.log $auth
# 		$rootScope.$on '$routeChangeStart', (event, next)->
# 			authorized = undefined
# 			if next.access != undefined
# 				authorized = AuthorizationService.authorize next.access.loginRequired, next.access.permissions, next.access.permissionCheckType

# 				#if authorized == 

# 	runAuth.$inject = ['$auth', '$location', '$rootScope', 'AuthorizationService']

# 	angular.module('clerkr').run(runAuth)