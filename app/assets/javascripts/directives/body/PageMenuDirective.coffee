directives = angular.module('directives')
directives.directive('pageMenu', [ ->
  {
    template: '
    <nav id="page-menu" class="navbar">
      <div class="navbar-header">
        <ul class="nav top-nav" ng-transclude>
        </ul>
      </div>
    </nav>'
    transclude: true
  }
])
