describe "ShowReportsController: ", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  resource     = null
  httpBackend  = null

  setupController = ()->
    inject(($routeParams, $rootScope, $resource, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      resource    = $resource
      routeParams = $routeParams
      httpBackend = $httpBackend 
      ctrl = $controller('ShowReportsController',
                         $scope: scope)  
      afterEach ->
        httpBackend.verifyNoOutstandingExpectation()
        httpBackend.verifyNoOutstandingRequest()
    )

  beforeEach ->
    module 'sessor'
    setupController()
    httpBackend.flush()



  describe 'when controller initializes', ->
    expect(scope.reports).not.toBeUndefined()