controllers = angular.module('controllers')
controllers.controller 'SortableController', ($scope) ->
  tmpList = []
  i = 1
  while i <= 6
    tmpList.push
      text: 'Item ' + i
      value: i
    i++
  $scope.list = tmpList
  $scope.sortingLog = []
  $scope.sortableOptions =
    update: (e, ui) ->
      logEntry = tmpList.map((i) ->
        i.value
      ).join(', ')
      $scope.sortingLog.push 'Update: ' + logEntry
      return
    stop: (e, ui) ->
      # this callback has the changed model
      logEntry = tmpList.map((i) ->
        i.value
      ).join(', ')
      $scope.sortingLog.push 'Stop: ' + logEntry
      return
  return