factories = angular.module('factories')
factories.factory("AuthServ", ["$cookieStore", '$http',
  ->
    login: (email, password, fn)->
      $cookieStore.put("currentUser", currentUser.name)
    logout: ()->
      currentUser = undefined
      $cookieStore.put("currentUser", currentUser)
    isLoggedIn: ()->
      return currentUser != undefined
])