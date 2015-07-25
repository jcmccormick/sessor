services = angular.module('services')
services.service('TemplateService', [->
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
      value: 'Radio'
      glyphicon: 'glyphicon-record'
    }
    {
      name: 'checkbox'
      value: 'Checkbox'
      glyphicon: 'glyphicon-check'
    }
    {
      name: 'dropdown'
      value: 'Dropdown'
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
      count: [{}]
    }
    {
      id: 2
      width: 'col-xs-6'
      count: [{}, {}]
    }
    {
      id: 3
      width: 'col-xs-4'
      count: [{}, {}, {}]
    }
  ]
])