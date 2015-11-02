directives = angular.module('directives')
directives.directive( 'draggableOptions', [->
  templateUrl: 'directives/templates/views/form/field_options.html'
  scope:
    field: '='
    form: '='
  link: (scope, element, attrs) ->
    $(element).draggable({
      addClasses: false
      containment: '.view-frame'
      handle: '.selected-field-options'
      scroll: false
    })

    $(element).draggable('disable')

    scope.$watch 'form.poppedOut', (active)->
      active && $(element).draggable("enable").addClass('ui-draggable').css({left:'50px',top:'50px'})
      !active && $(element).draggable("disable").removeClass('ui-draggable')


])