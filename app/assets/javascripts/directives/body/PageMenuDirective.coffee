directives = angular.module('directives')
directives.directive('pageMenu', [ ->
  {
    template: '
    <nav id="page-menu" class="navbar navbar-inverse">
      <div class="navbar-header">
        <ul class="nav navbar-left top-nav" ng-transclude>
        </ul>
      </div>
    </nav>'
    transclude: true
  }
])
