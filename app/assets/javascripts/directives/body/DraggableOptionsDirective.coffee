directives = angular.module('directives')
directives.directive( 'draggableOptions', [->
  scope: true
  link: (scope, element, attrs) ->
    $(element).draggable({
      addClasses: false
      containment: '.view-frame'
      handle: '.selected-field-options'
      scroll: false
    })

    $(element).draggable('disable')

    scope.$watch 'form.poppedOut', (newVal)->
      newVal && $(element).draggable("enable").addClass('ui-draggable').css({top: '50px',left: '50px'})
      !newVal && $(element).draggable("disable").removeClass('ui-draggable')


])