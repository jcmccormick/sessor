angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 750)

angular.module("sessor").run (['$rootScope', '$location', '$cacheFactory', '$http', '$window', 'Flash',
($rootScope, $location, $cacheFactory, $http, $window, Flash) ->

  $rootScope.$on('$routeChangeSuccess', ->
    $window.ga('send', 'pageview', { page: $location.url() })
    if !$rootScope.user.id && $location.url() == '/'
      $('.landing-page').removeClass('landing-hide')
  )


  $('input[rel="txtTooltip"]').tooltip()

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'

  $httpDefaultCache = $cacheFactory.get('$http')

  angular.forEach ['cleartemplates','clearreports'], (value) ->
    $rootScope.$on value, (event) ->
      $httpDefaultCache.removeAll()

  $rootScope.handleSignOut = ->
    $location.path('/sign_out')
    $rootScope.signOut()

  $rootScope.$on('auth:login-success', ->
    Flash.create('success', 'Successfully logged in.', 'customAlert')
    $location.path('/desktop/')
    $httpDefaultCache.removeAll()
  )

  $rootScope.$on('auth:logout-success', ->
    Flash.create('success', 'You\'ve been logged out.', 'customAlert')
    $location.path('/')
    $httpDefaultCache.removeAll()
  )

  $rootScope.$on('auth:invalid', ->
    error = "Looks like there was an error validating your credentials. Please try logging in again or contact support if problems continue."
    Flash.create('danger', error, 'customAlert')
    $location.path('/')
  )

  $rootScope.$on('auth:account-update-success', ->
    Flash.create('success', 'Account updated successfully.', 'customAlert')
  )

])