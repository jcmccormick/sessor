directives = angular.module('directives')
directives.directive('myDraggableDirective', ['$document',
  ($document) ->
    {
      restrict: 'E'
      transclude: true
      template: '<div>' + '<div ng-transclude></div>' + '</div>'
    }
    { link: (scope, element, attr) ->
      startX = 0
      startY = 0
      x = 0
      y = 0

      mousemove = (event) ->
        y = event.pageY - startY
        x = event.pageX - startX
        element.css
          top: y + 'px'
          left: x + 'px'
        return

      mouseup = ->
        $document.off 'mousemove', mousemove
        $document.off 'mouseup', mouseup
        rand = Math.floor( Math.random() * 1024 )
        console.log rand
        return

      element.css
        position: 'relative'
        border: '1px solid red'
        backgroundColor: 'lightgrey'
        cursor: 'pointer'
      element.on 'mousedown', (event) ->
        # Prevent default dragging of selected content
        event.preventDefault()
        startX = event.pageX - x
        startY = event.pageY - y
        $document.on 'mousemove', mousemove
        $document.on 'mouseup', mouseup
        return
      return
 }
])
directives.directive('dragSelectorDirective', [()->
  {
    restrict: 'E'
    transclude: true
    template: '<div>' + '<div ng-transclude></div>' + '</div>'
    controller: ($scope, $element, $attrs) ->
  }
])
directives.directive('draggerDirective',[($sce) ->
  {
    require: '^DragSelector'
    scope: selectedEngine: '='
    template: '<button dropdown-toggle class="dropdown" dropdown on-toggle="toggled(open)">' + '  <def class="dropdown-toggle">' + '    TEST    ' + '  </def>' + '  <ul>' + '<li ng-repeat="se in engines">' + '<a href="#" ng-click="setEngine(se)">{{se.name}}</a>' + '</li>' + '  </ul>' + '</button>'
    controller: ($scope, $element, $attrs) ->
    link: (scope, element, attrs, filterCtrl) ->
  }
])