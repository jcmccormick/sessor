directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$http', '$compile',
($http, $compile) ->
  getTemplate = (field) ->
    type = field.type
    supported_fields = [
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

    __indexOf = [].indexOf || (item)->
      i = 0
      for i in [0...this.length]
        if i in this && this[i] == item
          i++
          return i
      return -1

    if __indexOf.call(supported_fields, type) >= 0
      return type
    return

  linker = (scope, element) ->

    textfield = '
    <div class="form-group">
      <div class="form-label">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required</span>
      </div>
      <div>
        <input type="text" class="form-control" ng-model="field.value" value="{{field.value}}" ng-required="field.required" ng-disabled="field.disabled">
      </div>
    </div>'

    textarea = '
    <div class="form-group">
      <div class="form-label">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required</span>
      </div>
      <div>
        <textarea type="text" class="form-control" ng-model="field.value" value="{{field.value}}" ng-required="field.required" ng-disabled="field.disabled"></textarea>
      </div>
    </div>'

    email = '
    <div class="form-group">
      <div class="form-label">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required</span>
      </div>
      <input type="email" class="form-control" placeholder="Email" value="{{field.value}}" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled"/>
    </div>'

    checkbox = '
    <br>
    <input ng-model="field.value" id="{{field.id}}" type="checkbox" ng-true-value="1" ng-false-value="0" ng-required="field.required" ng-disabled="field.disabled"/>
    <label class="form-field-label" for="{{field.id}}" ng-cloak>{{field.title}}</label>
    <span class="required-error" ng-show="field.required && field.value == 0">(* required)</span>
    <br>'

    date = '
    <div class="form-group">
      <div class="form-label">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required </span>
      </div>
      <input type="date" class="form-control" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled">
    </div>'

    dropdown = '
    <div class="form-group">
      <div class="form-label">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required</span>
      </div>
      <select class="form-control" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled">
        <option ng-repeat="option in field.options" ng-selected="option.value == field.value" value="{{option.id}}">
          {{option.title}}
        </option>
      </select>
    </div>
    <br>'

    radio = '
    <div class="form-group">
      <div class="form-label">{{field.title}}: 
        <span class="required-error" ng-show="field.required && !field.value">* required</span>
      </div>
      <div class="form-control" ng-repeat="option in field.options">
        <input type="radio" value="{{option.value}}" ng-model="field.value"  ng-required="field.required" ng-disabled="field.disabled"/>
        &nbsp;<span ng-bind="option.title"></span>
      </div>
    </div>'

    # currently unused controls

    hidden = '
    <input type="hidden" ng-model="field.value" value="{{field.value}}" ng-disabled="field.disabled">'

    password = '
    <div class="field row">
      <div class="span2">{{field.title}}:
        <span class="required-error" ng-show="field.required && !field.value">* required</span></div>
      <div class="span4">
        <input type="password" ng-model="field.value" value="{{field.value}}"  ng-required="field.required" ng-disabled="field.disabled">
      </div>
    </div>'

    # GET template content from path
    template = getTemplate(scope.field)

    switch template
      when "textfield" then element.html textfield
      when "textarea" then element.html textarea
      when "email" then element.html email
      when "checkbox" then element.html checkbox
      when "date" then element.html date
      when "dropdown" then element.html dropdown
      when "hidden" then element.html hidden
      when "password" then element.html password
      when "radio" then element.html radio

    $compile(element.contents()) scope
    return

  {
    template: '<div>{{field}}</div>'
    restrict: 'E'
    scope: field: '='
    link: linker
  }
])