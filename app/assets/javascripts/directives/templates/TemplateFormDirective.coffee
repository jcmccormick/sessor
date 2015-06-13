directives = angular.module('directives')
directives.directive('templateFormDirective',[()->
  {
    templateUrl: 'directives/templates/views/form/form.html'
    restrict: 'E'
    scope: form: '='
  }
])