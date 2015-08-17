services = angular.module('services')
services.service('TemplateService', [->
  supportedFields: [
    'labelntext'
    'textfield'
    'textarea'
    'integer'
    'date'
    'time'
    'checkbox'
    'radio'
    'dropdown'
    'email'
    # 'masked'
  ]
  fields: [
    {
      name: 'labelntext'
      value: 'Label and Text'
      glyphicon: 'glyphicon-text-size'
    }
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
      name: 'email'
      value: 'E-mail'
      glyphicon: 'glyphicon-envelope'
    }
    {
      name: 'integer'
      value: 'Integer'
      glyphicon: 'glyphicon-th'
    }
    {
      name: 'date'
      value: 'Date'
      glyphicon: 'glyphicon-calendar'
    }
    {
      name: 'time'
      value: 'Time'
      glyphicon: 'glyphicon-time'
    }
    {
      name: 'checkbox'
      value: 'Checkbox'
      glyphicon: 'glyphicon-check'
    }
    {
      name: 'radio'
      value: 'Radio'
      glyphicon: 'glyphicon-record'
    }
    {
      name: 'dropdown'
      value: 'Dropdown'
      glyphicon: 'glyphicon-list'
    }
    # {
    #   name: 'masked'
    #   value: 'Masked'
    #   glyphicon: 'glyphicon-lock'
    # }
  ]
])