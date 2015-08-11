sessor = angular.module("sessor")
sessor.run (['$rootScope', '$location', '$cacheFactory', '$http', 'Flash',
($rootScope, $location, $cacheFactory, $http, Flash) ->

  $httpDefaultCache = $cacheFactory.get('$http')

  $rootScope.handleSignOut = ->
    $location.path('/desktop')
    $rootScope.signOut()

  $rootScope.$on('auth:login-success', ->
    $location.path('/desktop/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:logout-success', ->
    $location.path('/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:invalid', ->
    error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
    Flash.create('danger', error)
    $location.path('/')
    return
  )

  angular.forEach [
    'cleartemplates'
    'clearreports'
  ], (value) ->
    $rootScope.$on value, (event) ->
      $httpDefaultCache.removeAll()
      return
    return

  $('input[rel="txtTooltip"]').tooltip()

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
    return

])