services = angular.module('services')
services.service('TemplateService', ['$http', 
($http) ->
  formsJsonPath = '.templates/template/static-data/sample_forms.json'
  {
    fields: [
      {
        name: 'textfield'
        value: 'Text Line'
        glyphicon: 'glyphicon-font'
      }
      {
        name: 'textarea'
        value: 'Text Area'
        glyphicon: 'glyphicon-comment'
      }
      {
        name: 'radio'
        value: 'Radio Button'
        glyphicon: 'glyphicon-record'
      }
      {
        name: 'checkbox'
        value: 'Checkbox'
        glyphicon: 'glyphicon-check'
      }
      {
        name: 'dropdown'
        value: 'Dropdown List'
        glyphicon: 'glyphicon-list'
      }
      {
        name: 'date'
        value: 'Date'
        glyphicon: 'glyphicon-calendar'
      }
      {
        name: 'email'
        value: 'E-mail'
        glyphicon: 'glyphicon-envelope'
      }
    ]
    form: (id) ->
      # $http returns a promise, which has a then function, which also returns a promise
      $http.get(formsJsonPath).then (response) ->
        requestedForm = {}
        angular.forEach response.data, (form) ->
          if form.form_id == id
            requestedForm = form
          return
        requestedForm
    forms: ->
      $http.get(formsJsonPath).then (response) ->
        response.data

  }
])