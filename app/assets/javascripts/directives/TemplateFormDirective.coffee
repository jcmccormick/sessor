directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
  {
    controller: ['$scope', ($scope) ->

      $scope.submit = ->
        alert 'Form submitted..'
        $scope.form.submitted = true
        return

      $scope.cancel = ->
        alert 'Form canceled..'
        return

      return
    ]
    templateUrl: 'template/directive-templates/form/form.html'
    restrict: 'E'
    scope: form: '='
  }
])