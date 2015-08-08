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

    fwstart = '
    <div class="form-group">
      <label class="control-label">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.values[0].input">*</span>
      </label>'

    textfield = '<input type="text" class="form-control" ng-model="field.values[0].input" value="{{field.values[0].input}}" ng-required="field.required" ng-disabled="field.disabled">'

    textarea = '<textarea type="text" class="form-control" ng-model="field.values[0].input" value="{{field.values[0].input}}" ng-required="field.required" ng-disabled="field.disabled"></textarea>'

    email = '<input type="email" class="form-control" placeholder="Email" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled"/>'

    checkbox = '
    <div class="form-group">
      <input type="checkbox" ng-model="field.values[0].input" id="{{field.id}}" ng-required="field.required" ng-disabled="field.disabled">
      <label class="form-field-label" for="{{field.id}}">{{field.name}}
        <span class="required-error" ng-show="field.required && !field.values[0].input">*</span>
      </label>
      <div id="field-overlay" ng-if="!editing"></div>
    </div>'

    date = '<input type="datetime-local" class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">'

    dropdown = '<select class="form-control" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled" ng-options="option.name as option.name for option in field.options">
        <option value="">Select Item</option>
      </select>'

    radio = '<div ng-repeat="option in field.options">
        <input type="radio" name="{{field.id}}" value="{{option.name}}" ng-model="field.values[0].input" ng-required="field.required" ng-disabled="field.disabled">
        &nbsp;{{option.name}}
      </div>'

    password = '<input type="password" class="form-control" ng-model="field.values[0].input"  ng-required="field.required" ng-disabled="field.disabled">'

    hidden = '
    <input type="hidden" ng-model="field.values[0].input" value="{{field.values[0].input}}" ng-disabled="field.disabled">'

    fwend = '<div id="field-overlay" ng-if="!editing"></div>
      </div>'

    # GET template content from path
    template = getTemplate(scope.field)
    
    switch template
      when "textfield" then element.html fwstart+textfield+fwend
      when "textarea" then element.html fwstart+textarea+fwend
      when "email" then element.html fwstart+email+fwend
      when "checkbox"
        if scope.field.values[0].input?
          scope.field.values[0].input = scope.field.values[0].input == 't' ? 1 : 0
        element.html checkbox
      when "date"
        if scope.field.values
          scope.field.values[0].input = new Date(scope.field.values[0].input)
        element.html fwstart+date+fwend
      when "dropdown" then element.html fwstart+dropdown+fwend
      when "radio" then element.html fwstart+radio+fwend
      when "password" then element.html fwstart+password+fwend
      when "hidden" then element.html hidden

    $compile(element.contents()) scope
    return

  {
    template: '<div>{{field}}</div>'
    restrict: 'E'
    scope:
      field: '='
      editing: '='
    link: linker
  }
])