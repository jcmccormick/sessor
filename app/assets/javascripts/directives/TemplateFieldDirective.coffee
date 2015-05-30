directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$http', '$compile',
($http, $compile) ->
  getTemplate = (field) ->
    type = field.field_type
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
      <div class="form-label">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span>
      </div>
      <div>
        <input type="text" class="form-control" ng-model="field.field_value" value="{{field.field_value}}" ng-required="field.field_required" ng-disabled="field.field_disabled">
      </div>
    </div>'

    textarea = '
    <div class="form-group">
      <div class="form-label">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span>
      </div>
      <div>
        <textarea type="text" class="form-control" ng-model="field.field_value" value="{{field.field_value}}" ng-required="field.field_required" ng-disabled="field.field_disabled"></textarea>
      </div>
    </div>'

    email = '
    <div class="form-group">
      <div class="form-label">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span>
      </div>
      <input type="email" class="form-control" placeholder="Email" value="{{field.field_value}}" ng-model="field.field_value" ng-required="field.field_required" ng-disabled="field.field_disabled"/>
    </div>'

    checkbox = '
    <br>
    <input ng-model="field.field_value" id="{{field.field_id}}" type="checkbox" ng-true-value="1" ng-false-value="0" ng-required="field.field_required" ng-disabled="field.field_disabled"/>
    <label class="form-field-label" for="{{field.field_id}}" ng-cloak>{{field.field_title}}</label>
    <span class="required-error" ng-show="field.field_required && field.field_value == 0">(* required)</span>
    <br>'

    date = '
    <div class="form-group">
      <div class="form-label">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required </span>
      </div>
      <input type="date" class="form-control" ng-model="field.field_value" ng-required="field.field_required" ng-disabled="field.field_disabled">
    </div>'

    dropdown = '
    <div class="form-group">
      <div class="form-label">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span>
      </div>
      <select class="form-control" ng-model="field.field_value" ng-required="field.field_required" ng-disabled="field.field_disabled">
        <option ng-repeat="option in field.field_options" ng-selected="option.option_value == field.field_value" value="{{option.option_id}}">
          {{option.option_title}}
        </option>
      </select>
    </div>
    <br>'

    radio = '
    <div class="form-group">
      <div class="form-label">{{field.field_title}}: 
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span>
      </div>
      <div class="form-control" ng-repeat="option in field.field_options">
        <input type="radio" value="{{option.option_value}}" ng-model="field.field_value"  ng-required="field.field_required" ng-disabled="field.field_disabled"/>
        &nbsp;<span ng-bind="option.option_title"></span>
      </div>
    </div>'

    # currently unused controls

    hidden = '
    <input type="hidden" ng-model="field.field_value" value="{{field.field_value}}" ng-disabled="field.field_disabled">'

    password = '
    <div class="field row">
      <div class="span2">{{field.field_title}}:
        <span class="required-error" ng-show="field.field_required && !field.field_value">* required</span></div>
      <div class="span4">
        <input type="password" ng-model="field.field_value" value="{{field.field_value}}"  ng-required="field.field_required" ng-disabled="field.field_disabled">
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