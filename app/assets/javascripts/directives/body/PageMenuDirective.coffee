directives = angular.module('directives')
directives.directive('pageMenu', [ ->
  {
    template: '
    <div id="page-menu">
      <ul class="nav top-nav" ng-transclude></ul>
    </div>'
    transclude: true
  }
])
