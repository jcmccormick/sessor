services = angular.module('services')
services.service('TemplateService', ['$http', 
($http) ->
  formsJsonPath = ''
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
      {
        name: 'password'
        value: 'Protected'
        glyphicon: 'glyphicon-lock'
      }
    ]
    columns: [
      {
        id: 1
        width: 'col-xs-12 col-sm-12 col-md-12'
      }
      {
        id: 2
        width: 'col-xs-6 col-sm-6 col-md-6'
      }
      {
        id: 3
        width: 'col-xs-4 col-sm-4 col-md-4'
      }
    ]
    sections: [
      {
        title: 'Basic Personal Information',
        columns: [
          {
            id: 1,
            width: 'col-md-12 col-sm-12 col-xs-12',
            fields: [
              {
                id: 1,
                section: 1,
                column: 1,
                title: 'First Name',
                type: 'textfield',
                required: false,
                disabled: false,
                glyphicon: 'glyphicon-font'
              },
              {
                id: 2,
                section: 1,
                column: 1,
                title: 'Last Name',
                type: 'textfield',
                required: false,
                disabled: false,
                glyphicon: 'glyphicon-font'
              },
              {
                id: 3,
                section: 1,
                column: 1,
                title: 'E-mail',
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