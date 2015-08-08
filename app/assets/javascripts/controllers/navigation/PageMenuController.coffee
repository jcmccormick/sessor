controllers = angular.module('controllers')
controllers.controller("PageMenuController", ['$rootScope',
($rootScope)->
	vm = this

	$rootScope.$on('$routeChangeStart', (event, next, current)->
		console.log next
		vm.path = next.$$route.originalPath.split('/')
		vm.class = vm.path[1]
		vm.number = vm.path[2]
		vm.edit = vm.path[3]
	)

])