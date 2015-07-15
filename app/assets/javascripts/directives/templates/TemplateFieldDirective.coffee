directives = angular.module('directives')
directives.directive('templateFieldDirective', ['$http', '$compile', '$location', 'TemplateService',
($http, $compile, $location, TemplateService) ->
  
  getTemplate = (field) ->
    type = field.fieldtype
    supportedFields = TemplateService.supportedFields

    __indexOf = [].indexOf || (item)->
      i = 0
      for i in [0...this.length]
        if i in this && this[i] == item
          i++
          return i
      return -1

    if __indexOf.call(supportedFields, type) >= 0
      return type
    return

  linker = (scope, element) ->
    textfield = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <div>
        <input type="text" class="form-control" ng-model="field.value" value="{{field.value}}" ng-required="field.required" ng-disabled="field.disabled">
      </div>
    </div>'

    textarea = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <div>
        <textarea type="text" class="form-control" ng-model="field.value" value="{{field.value}}" ng-required="field.required" ng-disabled="field.disabled"></textarea>
      </div>
    </div>'

    email = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <input type="email" class="form-control" placeholder="Email" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled"/>
    </div>'

    checkbox = '
    <input ng-model="field.value" id="{{field.id}}" type="checkbox" ng-true-value="1" ng-false-value="0" ng-required="field.required" ng-disabled="field.disabled">
    <label class="form-field-label" for="{{field.id}}">{{field.name}}
      <span class="required-error" ng-show="field.required && field.value == 0">*</span>
    </label>
    <br>
    <br>'

    date = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <input type="datetime-local" min="2001-01-01T00:00:00" max="2019-12-31T00:00:00" placeholder="yyyy-MM-ddTHH:mm:ss" class="form-control" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled">
    </div>'

    dropdown = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <select class="form-control" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled">
        <option ng-repeat="option in field.options" ng-selected="option.value == field.value" value="{{option.id}}">
          {{option.name}}
        </option>
      </select>
    </div>'

    radio = '
    <div class="form-group">
      <label class="control-label">{{field.name}} 
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <div ng-repeat="option in field.options">
        <input type="radio" name="{{field.name}}{{field.id}}" value="{{option.name}}" ng-model="field.value" ng-required="field.required" ng-disabled="field.disabled"/>
        &nbsp;<span ng-bind="option.name"></span>
      </div>
    </div>'

    hidden = '
    <input type="hidden" ng-model="field.value" value="{{field.value}}" ng-disabled="field.disabled">'

    password = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.value">*</span>
      </label>
      <input type="password" class="form-control" value="{{field.value}}" ng-model="field.value"  ng-required="field.required" ng-disabled="field.disabled">
    </div>'

    # if scope.livesave = true && $location.path() = '/reports/new/'
    #   scope.field.disabled = false

    # GET template content from path
    template = getTemplate(scope.field)

    switch template
      when "textfield" then element.html textfield
      when "textarea" then element.html textarea
      when "email" then element.html email
      when "checkbox" then element.html checkbox
      when "date"
        scope.field.value = new Date(scope.field.value)
        element.html date
      when "dropdown" then element.html dropdown
      when "hidden" then element.html hidden
      when "password" then element.html password
      when "radio" then element.html radio

    $compile(element.contents()) scope
    return

  {
    template: '<div>{{field}}</div>'
    restrict: 'E'
    scope:
      field: '='
      livesave: '='
    link: linker
  }
])