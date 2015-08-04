directives = angular.module('directives')
directives.directive( 'sortableList', [->
  (scope, element, attrs) ->

    # variables used for dnd
    updateSections = undefined
    startIndex = -1

    # watch the model, so we always know what element
    # is at a specific position
    scope.$watch attrs.sortableList, ((value) ->
      updateSections = value
      return
    ), true

    # use jquery to make the element sortable (dnd). This is called
    # when the element is rendered
    $(element[0]).sortable
      start: (event, ui) ->

        # on start we define where the item is dragged from
        startIndex = $(ui.item).index()
        return
      stop: (event, ui) ->

        # on stop we determine the new index of the
        # item and store it there
        newIndex = $(ui.item).index()
        newSections = updateSections[startIndex]
        newColumns = scope.template.columns[startIndex]
        updateSections.splice startIndex, 1
        updateSections.splice newIndex, 0, newSections
        scope.template.columns.splice startIndex, 1
        scope.template.columns.splice newIndex, 0, newColumns
        scope.template.fields.forEach((field)->
          if field.section_id == startIndex+1
            field.section_id = newIndex+1
          else
            if field.section_id >= newIndex+1 && field.section_id < startIndex+1
              field.section_id = field.section_id+1

        )
        return
      axis: 'y'
    return
])