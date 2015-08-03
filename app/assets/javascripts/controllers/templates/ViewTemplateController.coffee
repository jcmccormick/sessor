controllers = angular.module('controllers')
controllers.controller('ViewTemplateController', ['$routeParams', '$scope', 'ClassFactory',
($routeParams, $scope, ClassFactory)->
	#ClassFactory.get({class: 'templates', id: $routeParams.templateId}).$promise.then((res)->
	#	$scope.template = res
	#)

	$scope.template = {}

	$scope.template.sections = ['Section One','Section Two','Section Three']
	$scope.template.columns = [2,3,1]
	$scope.template.fields = [
		{
		"section_id": 1
		"column_id": 1
		"name": "gat"
		}
		{
		"section_id": 1
		"column_id": 1
		"name": "hat"
		}
		{
		"section_id": 1
		"column_id": 1
		"name": "rat"
		}
		{
		"section_id": 1
		"column_id": 2
		"name": "bat"
		}
		{
		"section_id": 1
		"column_id": 2
		"name": "cat"
		}
		{
		"section_id": 2
		"column_id": 1
		"name": "snake"
		}
		{
		"section_id": 2
		"column_id": 2
		"name": "dog"
		}
		{
		"section_id": 2
		"column_id": 3
		"name": "hello"
		}
		{
		"section_id": 3
		"column_id": 1
		"name": "wait"
		}
		{
		"section_id": 3
		"column_id": 1
		"name": "5123123135"
		}
		{
		"section_id": 3
		"column_id": 1
		"name": "aaaaa5"
		}
	]
])