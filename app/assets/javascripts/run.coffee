angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 750)

angular.module("sessor").run (['$rootScope', '$location', '$cacheFactory', '$http', 'Flash',
($rootScope, $location, $cacheFactory, $http, Flash) ->

  $('input[rel="txtTooltip"]').tooltip()

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
    return

  $httpDefaultCache = $cacheFactory.get('$http')

  angular.forEach [
    'cleartemplates'
    'clearreports'
  ], (value) ->
    $rootScope.$on value, (event) ->
      $httpDefaultCache.removeAll()
      return
    return

  $rootScope.handleSignOut = ->
    $location.path('/sign_out')
    $rootScope.signOut()

  $rootScope.$on('auth:login-success', ->
    Flash.create('success', 'Successfully logged in.', 'customAlert')
    $location.path('/desktop/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:logout-success', ->
    Flash.create('success', 'You\'ve been logged out.', 'customAlert')
    $location.path('/')
    $httpDefaultCache.removeAll()
    return
  )

  $rootScope.$on('auth:invalid', ->
    error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue. Make sure cookies and Javascript are enabled in your browser options."
    Flash.create('danger', error, 'customAlert')
    $location.path('/')
    return
  )

  $rootScope.$on('auth:account-update-success', ->
    Flash.create('success', 'Account updated successfully.', 'customAlert')
    return
  )

])