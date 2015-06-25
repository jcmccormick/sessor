services = angular.module('services')
services.service('ParseMapService', [->
  map: (json)->
    $.map(JSON.parse(json), (value, index)->
      value.key = index
      return [value]
    )
])