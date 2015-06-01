directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
  {
    controller: ['$scope', ($scope) ->

      $scope.submitForm = ->
        alert 'Form submitted..'
        $scope.form.submitted = true
        return

      $scope.cancelForm = ->
        alert 'Form canceled..'
        return

      return
    ]
    templateUrl: 'template/directive-templates/form/form.html'
    restrict: 'E'
    scope: form: '='
  }
])