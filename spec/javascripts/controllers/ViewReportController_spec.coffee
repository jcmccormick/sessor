describe "ReportController", ->
  scope        = null
  ctrl         = null
  routeParams  = null
  httpBackend  = null
  reportId     = 1234

  fakeReport   =
    id: reportId
    name: "Patient Intake Form"
    template: [
      {
        id: 0
        title: 
        columns: [
        {
          id: 0
          fields: [
          {
            id: 0
            col: 
          }]
        }]
      }]

  setupController =(reportExists=true)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.reportId = reportId

      ctrl        = $controller('ReportController',
                                $scope: scope)
    )

  beforeEach(module("sessor"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()