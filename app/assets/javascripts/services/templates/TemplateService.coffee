services = angular.module('services')
services.service('TemplateService', ['$http', 
($http) ->
  formsJsonPath = ''
  {
    supportedProperties: [
      'id'
      'name'
      'type'
      'required'
      'disabled'
      'glyphicon'
      'value'
    ]
    supportedFields: [
      'textfield'
      'textarea'
      'email'
      'checkbox'
      'date'
      'dropdown'
      'hidden'
      'password'
      'radio'
    ]
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
      {
        name: 'password'
        value: 'Protected'
        glyphicon: 'glyphicon-lock'
      }
    ]
    columns: [
      {
        id: 1
        width: 'col-xs-12'
      }
      {
        id: 2
        width: 'col-xs-6'
      }
      {
        id: 3
        width: 'col-xs-4'
      }
    ]
    sections: [
      {
        name: 'Basic Personal Information',
        columns: [
          {
            id: 0,
            width: 'col-md-12',
            fields: [
              {
                id: 0,
                name: 'First Name',
                type: 'textfield',
                required: false,
                disabled: false,
                glyphicon: 'glyphicon-font'
              },
              {
                id: 1,
                name: 'Last Name',
                type: 'textfield',
                required: false,
                disabled: false,
                glyphicon: 'glyphicon-font'
              },
              {
                id: 2,
                name: 'E-mail',
                type: 'email',
                required: false,
                disabled: false,
                glyphicon: 'glyphicon-envelope'
              }
            ]
          }
        ]
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