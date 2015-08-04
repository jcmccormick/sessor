sessor = angular.module("sessor")
sessor.run (['$rootScope', '$location', '$cacheFactory', '$http', 'Flash',
($rootScope, $location, $cacheFactory, $http, Flash) ->

  $httpDefaultCache = $cacheFactory.get('$http')

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
    Flash.create('error', error)
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

  mobileDevice = if /Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent) then true else false

  if !mobileDevice
    $('ul.nav li.dropdown').hover (->
      $(this).delay(200).addClass('open')
      $(this).find('.dropdown-menu').first().stop(true, true).slideDown()
      return
    ), ->
      $(this).delay(200).removeClass('open')
      $(this).find('.dropdown-menu').first().stop(true, true).slideUp()
      return

  $(document).on 'click.nav li', '.navbar-collapse.in', (e) ->
    if $(e.target).is('a')
      $(this).removeClass('in').addClass 'collapse'
    return

  $(window).scroll (e) ->
    $el = $('.stick')
    if $(this).scrollTop() > 165 and $el.css('position') != 'fixed'
      $('.stick').addClass('mobile-stick')
      $('.stick').css
        'position': 'fixed'
        'top': '15px'
        'z-index': '1031'
    if $(this).scrollTop() < 165 and $el.css('position') == 'fixed'
      $('.stick').removeClass('mobile-stick')
      $('.stick').css
        'width': '100%'
        'position': 'relative'
        'top': '0'
        'z-index': '1000'
    return
])