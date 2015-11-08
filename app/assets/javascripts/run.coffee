angular.module('infinite-scroll').value('THROTTLE_MILLISECONDS', 750)

angular.module("sessor").run (['$auth', '$rootScope', '$location', '$cacheFactory', '$window', 'Flash',
($auth, $rootScope, $location, $cacheFactory, $window, Flash) ->

  $httpDefaultCache = $cacheFactory.get('$http')

  angular.forEach ['cleartemplates','clearreports'], (value) ->
    $rootScope.$on value, (event) ->
      $httpDefaultCache.removeAll()

  $rootScope.$on('$routeChangeStart', (evt, next, current)->
    if !$auth.user.id && next.$$route.originalPath == '/'
      !current && $auth.validateUser().then((res)->
        res.id && $location.path('/desktop')
      )
  )

  $rootScope.$on('$locationChangeStart', (evt, absNewUrl, absOldUrl)->
    ~absOldUrl.indexOf('reset_password=true') && $location.path('/pass_reset')
  )
  
  $rootScope.$on('$routeChangeSuccess', ->
    $window.ga('send', 'pageview', { page: $location.url() })
  )

  $rootScope.$on('auth:login-success', ->
    Flash.create('success', 'Successfully logged in.', 'customAlert')
    $location.path('/desktop/')
    $httpDefaultCache.removeAll()
  )

  $rootScope.$on('auth:logout-success', ->
    Flash.create('success', 'You have logged out.', 'customAlert')
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

  $rootScope.handleSignOut = ->
    $location.path('/sign_out')
    $rootScope.signOut()

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
  
  $(document).on 'scroll', (->
    $(this).scrollTop() > 50 && $('.form-header').addClass('slide-down')
    $(this).scrollTop() <= 50 && $('.form-header').removeClass('slide-down')
  )

])